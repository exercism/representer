# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the tree that Vim's own parser would read, with one form for each spelling
# that Vim reads the same way.
module Rosetta::Languages::Vimscript::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Vim reads an abbreviated command, such as `fun` or
    # `endf`, as the full command, and the grammar gives it the full name.
    # fun! F() ... endf  ->  (function_definition (bang) (function_declaration F (parameters)) (body))
    strip_tokens "let", "const", "unlet", "if", "elseif", "else", "endif", "for", "in", "endfor", "while",
                 "endwhile", "function", "endfunction", "return", "call", "eval", "execute", "throw", "try",
                 "catch", "finally", "endtry", "break", "continue", "echo", "scriptencoding"

    # Strip the brackets, commas and other punctuation, because they are
    # layout. Keep the `;` in `[a; rest]`, because it collects the rest of
    # the list.
    # f(a, b)  ->  (call_expression f a b)
    # {'a': 1}  ->  (dictionnary (dictionnary_entry "a" 1))
    strip_tokens "(", ")"
    strip_tokens "[", "]", ",", only_in: [:list, :list_assignment, :index_expression, :slice_expression]
    strip_tokens "{", "}", ",", only_in: [:dictionnary, :lambda_expression]
    strip_tokens ",", only_in: [:parameters, :call_expression]
    strip_tokens ":", only_in: [:dictionnary_entry, :slice_expression, :ternary_expression]
    strip_tokens "?", only_in: :ternary_expression
    strip_tokens "->", only_in: [:method_expression, :lambda_expression]
    strip_tokens ".", only_in: :field_expression
    strip_tokens "=", only_in: [:let_statement, :const_statement, :default_parameter]
    strip_tokens "!", only_in: :bang
    strip_tokens "&", only_in: :option

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a + b) * c  ->  (binary_operation (binary_operation a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. Vim reads a number with a leading 0 as
    # octal, and a number with a point as a float, so `1.0` and `1` stay
    # apart.
    # 0x1F  ->  31
    # 017  ->  15
    # 1.5e3  ->  1500.0
    numbers_are integer: :integer_literal,
                decimal: :float_literal,
                prefixes: { "0x" => 16, "0b" => 2, "0" => 8 },
                separators: []

    # These levels follow Vim's `:help expression-syntax`, where `*` binds
    # tighter than `+`, `-` and `..`.
    PRECEDENCE = { "+" => 1, "-" => 1, ".." => 1, "*" => 2, "/" => 2, "%" => 2 }.freeze

    # Vim keeps these names for its own variables (`v:count` and the rest),
    # so `l:count` in a function is never the same as `count`.
    VIM_VARIABLES = ["count", "errmsg", "shell_error", "this_session", "version"].freeze

    ESCAPES = { "n" => "\n", "t" => "\t", "r" => "\r", "\\" => "\\", '"' => '"' }.freeze

    # A sign in a chain of operators, which belongs to the operand after it
    # (see chain_items).
    Prefix = Struct.new(:token)
    private_constant :Prefix

    def call
      tree.tap do
        refuse_vim9_script!
        mark_brackets_that_only_group!
        write_signed_numbers_as_negations!
        write_spaced_dots_as_concatenation!
        write_every_concatenation_with_two_dots!
        group_arithmetic_by_vims_precedence!
        group_nested_conditionals_to_the_right!
        read_the_names_of_arguments!
        write_vim_variables_as_leaves!
        drop_the_scopes_that_vim_assumes!(tree, false)
        write_strings_as_their_values!
        write_literal_dictionaries_as_dictionaries!
        mark_the_names_each_statement_defines!
      end
    end

    private
    # Refuse a file in Vim9 script. Its declarations and types are words to
    # this grammar, so the tree can't show what the code does, and the file
    # gets Basic's representation instead.
    # vim9script
    # def g:Darts(x: any, y: any): number
    def refuse_vim9_script!
      raise Rosetta::CannotRepresent.new("parse_error", "The file uses Vim9 script") if vim9_script?
    end

    def vim9_script?
      first = tree.named_children.first
      return true if first && text_of(first) == "vim9script"

      find_all(tree, "(unknown_command_name) @name").any? { |match| match.node.text == "def" }
    end

    ### Expressions ###

    # Mark each pair of brackets that only groups with a node, because the
    # grammar gives the brackets as tokens of the expression around them.
    # The steps below then know which code was in brackets, and the engine
    # unwraps them at the end. Leave the brackets of a call and of a
    # function's parameters.
    # (a + b) * c  ->  (binary_operation (parenthesized_expression a + b) * c)
    def mark_brackets_that_only_group!
      each_node(tree) do |node, _|
        next if node.type == "parameters"

        node.children = children_with_groups(node)
      end
    end

    def children_with_groups(node)
      children = node.children
      own = own_brackets(node)
      return grouped(children) unless own

      [*grouped(children[0...own]), children[own], *grouped(children[(own + 1)...-1]), children.last]
    end

    # The index of a call's own opening bracket, which comes straight after
    # the function.
    def own_brackets(node)
      return unless node.type == "call_expression"

      function = node.children.rindex { |child| child.field == "function" }
      (function + 1...node.children.size).find { |index| node.children[index].type == "(" }
    end

    # Wraps each `(`, expression, `)` run of the children in a node.
    def grouped(children)
      stack = [[]]
      children.each do |child|
        if !child.named? && child.type == "("
          stack << [child]
        elsif !child.named? && child.type == ")" && stack.size > 1
          opening, *inner = stack.pop
          stack.last << build(:parenthesized_expression, *inner).tap { |group| group.field = opening.field }
        else
          stack.last << child
        end
      end
      stack.flatten(1)
    end

    # Write a number with a sign as a negation, because Vim reads the sign
    # as an operator.
    # -1  ->  (unary_operation - 1)
    def write_signed_numbers_as_negations!
      transform(tree, "[(integer_literal) (float_literal)] @number") do |match|
        number = match.node
        next nil unless number.text.start_with?("-")

        build(:unary_operation, token("-"), leaf(number.type, number.text.delete_prefix("-")))
      end
    end

    # Write a dot with spaces around it as concatenation, because the grammar
    # reads `a . b` as the member `b` of `a`, and Vim reads it as `a .. b`.
    # The concatenation then holds anything that follows the member, such as
    # a call, because those bind tighter.
    # a . b  ->  (binary_operation a .. b)
    # a . b(1)  ->  (binary_operation a .. (call_expression b 1))
    def write_spaced_dots_as_concatenation!
      concatenations = Set.new.compare_by_identity
      postfix = "[(field_expression) (call_expression) (index_expression) (slice_expression) (method_expression)] @e"
      transform(tree, postfix) do |match|
        node = match.node
        inner = node[node.type == "call_expression" ? :function : :value]
        if spaced_dot?(node)
          concatenation(node[:value], node[:field]).tap { |result| concatenations << result }
        elsif concatenations.include?(inner)
          member = build(node.type, *node.children)
          member.replace_child(inner, inner[:right])
          concatenation(inner[:left], member).tap { |result| concatenations << result }
        end
      end
      drop(tree, "(fragment)")
    end

    # A line continuation (a new line, spaces and `\`) joins the lines, so
    # only the spaces after it count.
    def spaced_dot?(node)
      node.type == "field_expression" &&
        node.children.any? { |child| child.type == "fragment" && child.text.gsub(/\n\s*\\/, "").match?(/\s/) }
    end

    def concatenation(left, right) = build(:binary_operation, { left: }, token(".."), { right: })

    # Write every concatenation with `..`, because Vim reads `.` and `..`
    # as the same operator.
    # a . b  ->  a .. b
    # let s .= t  ->  let s ..= t
    def write_every_concatenation_with_two_dots!
      each_node(tree) do |node, _|
        next unless ["binary_operation", "let_statement"].include?(node.type)

        node.children.each do |child|
          next if child.named?

          child.type = child.text = ".." if child.type == "."
          child.type = child.text = "..=" if child.type == ".="
        end
      end
    end

    # Group each chain of `+`, `-`, `..`, `*`, `/` and `%` by Vim's
    # precedence, from the left, because the grammar sometimes groups a
    # chain with `..` from the right. Code in brackets stays one operand.
    # a - b .. c  ->  (binary_operation (binary_operation a - b) .. c)
    def group_arithmetic_by_vims_precedence!
      transform(tree, "[(binary_operation) (unary_operation)] @e") do |match|
        node = match.node
        next nil unless chain?(node) || (node.type == "unary_operation" && chain?(node.named_children.first))

        parse_chain(chain_items(node), 1)
      end
    end

    def chain?(node) = node&.type == "binary_operation" && PRECEDENCE.key?(operator(node)&.type)
    def operator(node) = node.children.find { |child| !child.named? }

    # The operands, operators and signs of a chain, in source order.
    def chain_items(node)
      return [*chain_items(node[:left]), operator(node), *chain_items(node[:right])] if chain?(node)

      operand = node.named_children.first
      return [Prefix.new(operator(node)), *chain_items(operand)] if node.type == "unary_operation" && chain?(operand)

      [node]
    end

    # Builds the chain's tree, taking the items from the front.
    def parse_chain(items, lowest)
      left = parse_operand(items)
      while (operator = items.first).is_a?(Rosetta::Engine::Node) && !operator.named? &&
            PRECEDENCE.fetch(operator.type) >= lowest
        items.shift
        right = parse_chain(items, PRECEDENCE.fetch(operator.type) + 1)
        left = build(:binary_operation, { left: }, operator, { right: })
      end
      left
    end

    def parse_operand(items)
      item = items.shift
      item.is_a?(Prefix) ? build(:unary_operation, item.token, parse_operand(items)) : item
    end

    # Group a conditional inside the condition of another from the right,
    # because Vim does and the grammar groups them from the left.
    # a ? b : c ? d : e  ->  a ? b : (c ? d : e)
    def group_nested_conditionals_to_the_right!
      transform(tree, "(ternary_expression condition: (ternary_expression)) @conditional") do |match|
        regroup_conditional(match.node)
      end
    end

    def regroup_conditional(outer)
      inner = outer[:condition]
      return outer unless inner&.type == "ternary_expression"

      rest = build(:ternary_expression, { condition: inner[:right] }, { left: outer[:left] }, { right: outer[:right] })
      build(:ternary_expression, { condition: inner[:condition] }, { left: inner[:left] },
            { right: regroup_conditional(rest) })
    end

    ### Names ###

    # Read the name of each argument, so that representation/spec.rb can
    # rename it with its parameter. Keep the number of `a:0`, the count of
    # the extra arguments, apart from `a:000`, their list.
    # a:name  ->  (argument name)
    # a:000  ->  (argument 000)
    def read_the_names_of_arguments!
      transform(tree, "(argument) @argument") do |match|
        name = match.node.text.delete_prefix("a:")
        build(:argument, leaf(name.match?(/\A\d+\z/) ? :vararg : :identifier, name))
      end
    end

    # Write each of Vim's own variables as one leaf, so that it keeps its
    # name if the solution defines a variable of the same name.
    # v:val  ->  v:val
    def write_vim_variables_as_leaves!
      transform(tree, '(scoped_identifier (scope) @scope)') do |match|
        leaf(:vim_variable, text_of(match.node)) if match[:scope].text == "v:"
      end
    end

    # Drop the scope from a name if Vim gives the name that scope anyway: in
    # a function, a name with no scope is local, and outside functions it
    # is global. A function's name with no scope is global too.
    # function F() | let l:total = 0 | endfunction  ->  function F() | let total = 0 | endfunction
    # let g:limit = 10  ->  let limit = 10
    # call g:Response()  ->  call Response()
    def drop_the_scopes_that_vim_assumes!(node, in_function)
      node.children.map! do |child|
        inside = in_function || child.type == "function_definition"
        child = unscoped(child) if assumed_scope?(child, node, inside)
        drop_the_scopes_that_vim_assumes!(child, inside)
        child
      end
    end

    def assumed_scope?(node, parent, in_function)
      return false unless node.type == "scoped_identifier"

      name = node.children.last
      case node.children.first.text
      when "l:" then in_function && name.type == "identifier" && !VIM_VARIABLES.include?(name.text)
      when "g:" then !in_function || function_name?(node, parent)
      else false
      end
    end

    def function_name?(node, parent)
      (parent.type == "function_declaration" && node.field == "name") ||
        (parent.type == "call_expression" && node.field == "function")
    end

    def unscoped(node) = node.children.last.tap { |name| name.field = node.field }

    ### Strings ###

    # Turn each string into its value, however it is quoted. A string in
    # single quotes reads `''` as a quote, and a string in double quotes
    # reads its escapes. Keep any other escape as a node of its own, so it
    # can't make two different strings the same.
    #
    # 'it''s'  ->  "it's"
    # "a\tb"  ->  "a\tb"
    # "a\x41"  ->  (string "a" (escape_sequence \x) "41")
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        text = match.node.text
        content = text[1...-1]
        next literal(content.gsub("''", "'")) if text.start_with?("'")

        string_node(content.scan(/\\.|[^\\]+/m).map { |piece| escape(piece) })
      end
    end

    def escape(piece)
      return piece unless piece.start_with?("\\")

      ESCAPES.fetch(piece[1]) { leaf(:escape_sequence, piece) }
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    # Write each literal dictionary as a dictionary with strings as its
    # keys, because Vim reads them as the same.
    # #{name: 1}  ->  {'name': 1}
    def write_literal_dictionaries_as_dictionaries!
      transform(tree, "(literal_dictionary) @dictionary") do |match|
        keys = match.node.children.select { |child| child.field == "key" }
        values = match.node.children.select { |child| child.field == "value" }
        entries = keys.zip(values).map { |key, value| build(:dictionnary_entry, { key: literal(key.text) }, { value: }) }
        build(:dictionnary, *entries)
      end
    end

    # Give each name that a statement defines the field `name`, so that
    # representation/spec.rb can list the statements that define names.
    # let «total» = 0
    # let [«first»; «rest»] = list
    # let s:«count» = 0
    # function! s:obj.«Method»() dict
    def mark_the_names_each_statement_defines!
      each_node(tree) do |node, _|
        case node.type
        when "let_statement", "const_statement" then mark_defined(node.named_children.first)
        when "for_loop" then mark_defined(node[:variable])
        when "function_declaration" then mark_defined(node[:name])
        when "lambda_expression" then lambda_parameters(node).each { |parameter| parameter.field = "name" }
        end
      end
    end

    def mark_defined(node)
      case node&.type
      when "identifier" then node.field = "name"
      when "scoped_identifier" then node.children.last.field = "name"
      when "field_expression" then node[:field].field = "name"
      when "list_assignment" then node.named_children.each { |target| mark_defined(target) }
      end
    end

    # The parameters of a lambda come before its `->`.
    def lambda_parameters(node)
      arrow = node.children.index { |child| !child.named? && child.type == "->" }
      node.children[0...arrow].select { |child| child.type == "identifier" }
    end
  end
end
