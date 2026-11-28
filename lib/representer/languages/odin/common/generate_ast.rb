# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Odin's own parser (core:odin/parser) gives.
module Representer::Languages::Odin::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # return x  ->  (return_statement x)
    strip_tokens "package", "import", "proc", "struct", "enum", "union", "bit_set", "bit_field", "map", "matrix",
                 "distinct", "where", "if", "else", "for", "switch", "case", "defer", "return", "break",
                 "continue", "or_return", "or_break", "or_continue", "do"

    # Strip the brackets, commas and other punctuation, because they are
    # layout. A `;` between statements is the same as a new line.
    # f(a, b)  ->  (call_expression f a b)
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";", ".", "..", "::", "->", "@", "#+"

    # Strip the `:` between a name and its type, and the `=` between a name
    # and its value, because the node types already show them.
    # a: int  ->  (field a int)
    # Point{x = 1}  ->  (struct Point (struct_field x 1))
    strip_tokens ":", "="

    # Keep the `;` in a `for` statement, because it shows which part is which.
    # for i := 0; ; {} and for ; ; i += 1 {}
    keep_tokens ";", in: :for_statement

    # Keep the `:` where it tells two programs apart.
    # x: int = 1 and x: int : 1
    # a[1:] and a[:1]
    # case a: b and case a, b:
    # proc(a, b: int) and proc(a, b, int)
    keep_tokens ":", in: [:var_declaration, :slice_expression, :switch_case, :parameter]

    # Keep the `=` where it tells two programs apart.
    # x = 1 and x := 1
    # f(a = 1) and f(a, 1)
    # @(a = b) and @(a, b)
    # proc(a: int = b) and proc(a: int b)
    keep_tokens "=", in: [:assignment_statement, :var_declaration, :call_expression, :attribute, :parameter]

    # Unwrap brackets that only group, and the node the grammar puts around
    # each type, because the tree's shape shows the grouping. Odin's parser
    # reads a single result in brackets as the same result without them.
    # (a + b)  ->  a + b
    # x: int  ->  (var_declaration x : int)
    # proc() -> (int)  ->  proc() -> int
    unwrap :parenthesized_expression, :type, :tuple_type

    # Write each number as its value.
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: :number,
                decimal: :float

    NAMES_BEFORE = {
      "procedure_declaration" => "::",
      "overloaded_procedure_declaration" => "::",
      "struct_declaration" => "::",
      "union_declaration" => "::",
      "bit_field_declaration" => "::",
      "const_declaration" => "::",
      "const_type_declaration" => ":",
      "var_declaration" => ":",
      "variable_declaration" => ":=",
      "assignment_statement" => ":=",
      "default_parameter" => ":=",
      "default_type" => ":=",
      "parameter" => ":",
      "field" => ":",
      "struct_member" => ":",
      "named_type" => ":",
      "label_statement" => ":",
      "for_statement" => "in"
    }.freeze

    ESCAPES = {
      '\a' => "\a",
      '\b' => "\b",
      '\e' => "\e",
      '\f' => "\f",
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\v' => "\v",
      '\\\\' => "\\",
      "\\'" => "'",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_negative_numbers_as_negations!
        write_strings_as_their_values!
        put_each_do_body_in_a_block!
        write_each_ternary_the_same_way!
        give_type_assertions_their_own_type!
        give_the_blank_identifier_its_own_type!
        mark_the_names_each_declaration_defines!
      end
    end

    private
    ### Values ###

    # Write a negative number as `-` applied to the number, as Odin's parser
    # does. The grammar reads `-1` as one number, and `- 1` as a negation.
    # -1  ->  (unary_expression - 1)
    def write_negative_numbers_as_negations!
      transform(tree, "[(number) (float)] @number") do |match|
        number = match.node
        build(:unary_expression, token("-"), leaf(number.type, number.text[1..])) if number.text.start_with?("-")
      end
    end

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings
    # the same. A raw string has no escapes.
    # `a`  ->  "a"
    # "\x41é"  ->  "Aé"
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        string_node(match.node.named_children.map { |part| part.type == "escape_sequence" ? escape(part) : part.text })
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as half of a surrogate pair or a
    # byte above 127.
    def escape(node)
      code = node.text[1..]
      case code
      when /\A(?:u\h{4}|U\h{8})\z/
        value = code[1..].to_i(16)
        value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
      when /\Ax\h{2}\z/ then ascii(code[1..].to_i(16), node)
      when /\A[0-7]{3}\z/ then ascii(code.to_i(8), node)
      else ESCAPES.fetch(node.text, node)
      end
    end

    def ascii(value, node) = value < 0x80 ? value.chr : node

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    ### Statements ###

    # Put the statement after each `do` in a block, as Odin's parser does.
    # if x do return 1  ->  if x { return 1 }
    def put_each_do_body_in_a_block!
      each_node(tree) do |node, _|
        start = node.children.index { |child| !child.named? && child.type == "do" }
        next unless start

        stop = ((start + 1)...node.children.size).find do |i|
          node.children[i].named? && node.children[i].type != "tag"
        end
        body = build(:block, *node.children[(start + 1)..stop]).tap { |block| block.field = "consequence" }
        node.children = node.children[0...start] + [body] + node.children[(stop + 1)..]
      end
    end

    ### Expressions ###

    # Write `x if c else y` as `c ? x : y`, because Odin's parser reads both as
    # the same expression. Keep the `when` of a ternary that the compiler
    # decides.
    # a if b else c  ->  (ternary_expression b a c)
    # a when b else c  ->  (ternary_expression b when a c)
    def write_each_ternary_the_same_way!
      transform(tree, "(ternary_expression) @ternary") do |match|
        first, middle, last = match.node.named_children
        case match.node.children[1].type
        when "?" then build(:ternary_expression, first, middle, last)
        when "if" then build(:ternary_expression, middle, first, last)
        else build(:ternary_expression, middle, token("when"), first, last)
        end
      end
    end

    # Give `x.(T)` and `x.?` a type of their own, because they assert a
    # union's type, and their brackets are part of the syntax.
    # v.(int)  ->  (type_assertion v int)
    # v.?  ->  (type_assertion v ?)
    def give_type_assertions_their_own_type!
      transform(tree, "(member_expression (_) [(parenthesized_expression) \"?\"]) @assertion") do |match|
        value, type = match.node.children.reject { |child| !child.named? && child.type == "." }
        build(:type_assertion, value, type.named? ? type.named_children.first : type)
      end
    end

    ### Names ###

    # Give `_` a type of its own, because it defines no name.
    # for _, x in xs  ->  (for_statement (blank_identifier _) x in xs ...)
    def give_the_blank_identifier_its_own_type!
      each_node(tree) { |node, _| node.type = "blank_identifier" if node.type == "identifier" && node.text == "_" }
    end

    # Give the field `name` to each name that a declaration defines, so
    # representation/spec.rb can list them as definitions. A declaration defines
    # the names before its `::`, `:=`, `:` or `in`, a type switch defines the
    # name before its `in`, and a `$` defines the name after it.
    # a, b := f()  ->  (assignment_statement a b := f())
    # for &x, i in xs  ->  (for_statement (unary_expression & x) i in xs ...)
    # proc(x: $T)  ->  (parameter x : (constant_type $ T))
    def mark_the_names_each_declaration_defines!
      each_node(tree) do |node, parent|
        separator = NAMES_BEFORE[node.type]
        separator = "in" if node.type == "in_expression" && parent&.type == "switch_statement"
        stop = separator && node.children.index { |child| !child.named? && child.type == separator }
        node.children[0...stop].each { |child| mark_name(child) } if stop
        node.children.each_cons(2) { |before, child| mark_name(child) if !before.named? && before.type == "$" }
      end
    end

    # Give a name the field `name`. A `type` around the name passes the field
    # on to it when it is unwrapped.
    def mark_name(node)
      case node.type
      when "identifier" then node.field = "name"
      when "type" then node.field = "name" if node.named_children.map(&:type) == ["identifier"]
      when "unary_expression" then mark_name(node.named_children.last)
      end
    end
  end
end
