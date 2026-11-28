# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that a CFML engine's parser (Lucee's or Adobe
# ColdFusion's) gives.
module Rosetta::Languages::CFML::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y; }  ->  (if_statement x (statement_block (return_statement y)))
    strip_tokens "component", "function", "return", "if", "else", "elseif", "for", "while", "do", "break", "continue",
                 "throw", "try", "catch", "finally", "switch", "case", "new", "import", "property"

    # Strip the `default` of a `switch`, because the node type shows it.
    # Elsewhere `default` is an access level.
    strip_tokens "default", only_in: :switch_default

    # Strip the `var` that starts a declaration, because the node type shows
    # it. Keep the `var` in a loop's or `catch`'s header, because it makes
    # the variable local.
    # var x = 1;  ->  (variable_declaration (variable_declarator x 1))
    strip_tokens "var", only_in: :variable_declaration

    # Strip the `in` of a `for ... in` loop, because the node type shows it.
    # Elsewhere `in` is an operator.
    strip_tokens "in", only_in: :for_in_statement

    # Strip the brackets, commas, `=` and other punctuation, because they are
    # layout.
    # f(a, b);  ->  (call_expression f (arguments a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "?", "?:", "="

    # Keep the `:` of an assignment, because `=` and `:` are different
    # spellings there.
    keep_tokens ":", in: :assignment_expression

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Unwrap the `#` around an expression too, because the parser
    # reads `#x#` outside a string as `x`, and the string's node shows where
    # an expression sits inside it.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # "a#b#"  ->  (string "a" b)
    unwrap :parenthesized_expression, :hash_expression

    # Write each number as its value. A number has no other base and no
    # digit separators, and a leading zero doesn't make it octal. An integer
    # stays apart from a decimal.
    #
    # 010  ->  10
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: {},
                separators: []

    # CFML spells most operators in words as well as in symbols, and the
    # parser reads each word as its symbol.
    OPERATORS = {
      "and" => "&&",
      "or" => "||",
      "mod" => "%",
      "eq" => "==",
      "is" => "==",
      "equal" => "==",
      "neq" => "!=",
      "is not" => "!=",
      "not equal" => "!=",
      "<>" => "!=",
      "lt" => "<",
      "less than" => "<",
      "lte" => "<=",
      "le" => "<=",
      "less than or equal to" => "<=",
      "gt" => ">",
      "greater than" => ">",
      "gte" => ">=",
      "ge" => ">=",
      "greater than or equal to" => ">=",
      "ct" => "contains",
      "nct" => "does not contain"
    }.freeze

    # These scopes hold variables, so an assignment to one of their keys
    # defines a variable.
    SCOPES = ["this", "variables", "local"].freeze

    def call
      tree.tap do
        drop_empty_statements!
        write_strings_as_their_values!
        build_each_parameter!
        write_a_lone_arrow_parameter_in_brackets!
        write_both_struct_literals_the_same_way!
        write_elseif_as_else_if!
        mark_named_arguments_and_attributes!
        mark_return_types!
        write_word_operators_as_symbols!
        write_names_in_lower_case!
        mark_variables_set_on_scopes!
      end
    end

    private
    # Drop each `;` that stands on its own, because the parser reads it as
    # no statement.
    # f(); ;  ->  f();
    def drop_empty_statements!
      drop(tree, "(empty_statement)")
    end

    ### Values ###

    # Turn each string into its value, however it is quoted. A doubled quote
    # stands for one quote, and `##` stands for `#`. A string with an
    # expression in it keeps the expression, with the text around it as
    # values.
    #
    # 'a'  ->  "a"
    # 'it''s'  ->  "it's"
    # "a##b"  ->  "a#b"
    # "a#n#"  ->  (string "a" (hash_expression n))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        string_node(match.node.children.filter_map { |part| string_piece(part) })
      end
    end

    # Return a string part's text, or its node if it is an expression. Return
    # nil for the quotes around the string.
    def string_piece(part)
      case part.type
      when "string_fragment" then part.text
      when "hash_empty" then "#"
      when "\"\"" then '"'
      when "''" then "'"
      when "\"", "'" then nil
      else part
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or
    # a string of literals and expressions. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    ### Parameters ###

    # Give each parameter a node of its own, with its type, name and default
    # in fields, as the parser does. The grammar lists the parts of every
    # parameter one after another, and gives a parameter with no type its
    # name as a type.
    #
    # (required string name, n = 1)  ->  (formal_parameters (parameter required type: string name: name)
    #                                                       (parameter name: n default: 1))
    def build_each_parameter!
      each_node(tree) do |node, _|
        next unless node.type == "formal_parameters"

        groups = node.children.slice_when { |a, _| a.type == "," }
        node.children.replace(groups.map { |group| parameter(group.reject { |part| ["(", ")", ","].include?(part.type) }) }.compact)
      end
    end

    # Build one parameter from its parts. Return nil if it has none, as in
    # `()`.
    def parameter(parts)
      return nil if parts.empty?

      types = parts.select { |part| part.type == "parameter_type" }
      default = parts.find { |part| part.type == "assignment_pattern" }
      name = default ? default[:left] : parts.find { |part| part.type == "identifier" }
      name ||= leaf(:identifier, types.pop.text)
      others = parts.reject { |part| part.type == "parameter_type" || part.equal?(name) || part.equal?(default) }
      build(:parameter, *others, { type: types.first && leaf(:type, types.first.text), name:, default: default&.[](:right) })
    end

    # Put an arrow function's lone parameter in brackets, as the parser
    # does.
    # x => x  ->  (x) => x
    def write_a_lone_arrow_parameter_in_brackets!
      transform(tree, "(arrow_function parameter: (identifier) @name)") do |match|
        parameters = build(:formal_parameters, build(:parameter, { name: copy(match[:name]) }))
        match.node.replace_child(match[:name], parameters)
        parameters.field = "parameters"
        match.node
      end
    end

    ### Structs ###

    # Write a struct literal with `=` the same way as one with `:`, because
    # the parser reads them as the same struct. The grammar reads the
    # first as a destructuring pattern, which CFML doesn't have.
    # {a = 1, "b" = 2}  ->  {a: 1, "b": 2}
    def write_both_struct_literals_the_same_way!
      transform(tree, "(object_assignment_pattern left: (_) @key right: (_) @value)") do |match|
        build(:pair, { key: leaf(:property_identifier, text_of(match[:key])), value: match[:value] })
      end
      retype(tree, object_pattern: :object, cf_pair: :pair)
    end

    ### Statements ###

    # Write `elseif` as `else if`, because the parser reads them as the same.
    # if (a) {} elseif (b) {}  ->  if (a) {} else if (b) {}
    def write_elseif_as_else_if!
      transform(tree, "(else_if_clause) @clause") do |match|
        build(:else_clause, build(:if_statement, *match.node.children))
      end
    end

    ### Names ###

    # Give the `name = value` pairs in a call and after a function's
    # parameters types of their own, because they name an argument or an
    # attribute and assign no variable.
    # f(name = "x")  ->  (call_expression f (arguments (named_argument name "x")))
    # function f() output=false {}  ->  (function_declaration f (formal_parameters) (function_attribute output false) ...)
    def mark_named_arguments_and_attributes!
      each_node(tree) do |node, parent|
        next unless node.type == "assignment_expression"

        node.type = "named_argument" if parent&.type == "arguments"
        node.type = "function_attribute" if parent&.type == "function_declaration"
      end
    end

    # Mark a function's return type as a type, so that it is never renamed
    # as a name.
    # string function f() {}  ->  (function_declaration (type string) f ...)
    def mark_return_types!
      each_node(tree) do |node, _|
        next unless node.type == "function_declaration"

        node.children.each { |child| child.type = "type" if child.type == "identifier" && child.field.nil? }
      end
    end

    # Write each word operator as its symbol, in any case and with any
    # spaces, because the parser reads them as the same operator.
    # a EQ b AND NOT c  ->  a == b && !c
    # a IS NOT b  ->  a != b
    def write_word_operators_as_symbols!
      each_node(tree) do |node, _|
        case node.type
        when "binary_expression" then write_operator_as_symbol(node)
        when "not_operator" then node.children.replace([token("!")])
        end
      end
    end

    def write_operator_as_symbol(node)
      operators = node.children.select { |child| child.field == "operator" }
      text = operators.map { |operator| text_of(operator) }.join(" ").downcase.split.join(" ")
      symbol = token(OPERATORS.fetch(text, text)).tap { |operator| operator.field = "operator" }
      node.children[node.children.index(operators.first)] = symbol
      node.children.reject! { |child| operators.include?(child) }
    end

    # Write every name and keyword in lower case, because CFML ignores their
    # case. Strings are values by now, and keep their case.
    # Total = ArrayLen(Values)  ->  total = arraylen(values)
    # PUBLIC FUNCTION f()  ->  public function f()
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        node.text = node.text.downcase if node.leaf? && !node.quoted
      end
    end

    # Mark each variable that an assignment sets on the `this`, `variables`
    # or `local` scope, so that representation/spec.rb can list it with the other
    # definitions.
    # local.count = 0  ->  (assignment_expression (scope_property local count) 0)
    def mark_variables_set_on_scopes!
      captured(tree, "(assignment_expression left: (member_expression) @name)").each do |member|
        object = member[:object]
        member.type = "scope_property" if object.type == "this" || SCOPES.include?(object.text)
      end
    end
  end
end
