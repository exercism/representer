# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the F# compiler's parser (its untyped syntax tree)
# gives.
module Rosetta::Languages::FSharp::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if a then 1 else if b then 2 else 3  ->  if a then 1 elif b then 2 else 3
    strip_tokens "let", "module", "namespace", "type", "fun", "function", "if", "then", "else", "elif", "else if",
                 "match"

    # Strip the brackets and separators, because they are layout.
    # let total = add(x)  ->  let total = add x
    strip_tokens "(", ")", "[", "]", "{", "}", "[|", "|]", ";", ","

    # Write each number as its value. A number with a type suffix, such as
    # `10L`, keeps it.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: [:int, :xint],
                decimal: :float

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\b' => "\b",
      '\a' => "\a",
      '\f' => "\f",
      '\v' => "\v",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_every_operator_as_a_leaf!
        regroup_operators_and_calls!(tree)
        unwrap_brackets_that_only_group!
        drop_bars_between_match_union_and_enum_cases!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Brackets ###

    # Unwrap brackets that only group, because the tree's shape now shows the
    # grouping. This step runs after regrouping the operators, which needs
    # the brackets, and before marking the names, which needs them gone.
    # a + (b * c)  ->  a + b * c
    def unwrap_brackets_that_only_group!
      unwrap(tree, "[(paren_expression) (paren_pattern)]")
    end

    ### Strings ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as it is written, so it can't make two
    # different strings the same.
    #
    # @"a""b"  ->  "a\"b"
    # """a"b"""  ->  "a\"b"
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        parts = match.node.children
        next nil unless parts.all? { |part| ["fragment", '"'].include?(part.type) }

        literal(parts.select { |part| part.type == "fragment" }.sum("") { |part| unescape(part.text) })
      end
      transform(tree, '(verbatim_string /\A@"/) @string') { |match| literal(match.node.text[2..-2].gsub('""', '"')) }
      transform(tree, '(triple_quoted_string /\A"""/) @string') { |match| literal(match.node.text[3..-4]) }
    end

    def unescape(text)
      text.gsub(/\\(?:u(\h{4})|U(\h{8})|x(\h{2})|(.))/m) do |escape|
        hex = Regexp.last_match(1) || Regexp.last_match(2) || Regexp.last_match(3)
        next ESCAPES.fetch(escape, escape) unless hex

        code = hex.to_i(16)
        code.between?(0xD800, 0xDFFF) || code > 0x10FFFF ? escape : [code].pack("U")
      end
    end

    ### Operators ###

    # Write each operator as a leaf. The grammar writes an operator as a
    # leaf in some places, and as a node holding one token in others.
    def write_every_operator_as_a_leaf!
      transform(tree, "[(infix_op) (prefix_op)] @op") do |match|
        children = match.node.children
        leaf(match.node.type, children.first.text) if children.one? && !children.first.named?
      end
    end

    # Group operators and function calls by F#'s rules. The grammar reads
    # every operator from left to right with the same precedence, and
    # sometimes reads a function as an operator's operand.
    #
    # e.g. The grammar reads:
    # a + f b * c
    #
    # as:
    # ((a + f) b) * c
    #
    # and we convert it into:
    # a + ((f b) * c)
    #
    # This stage lists the operands and operators of each such chain in
    # source order, and groups them again (see Chain). A bracketed
    # expression, a method call such as `f(x)` and any other expression
    # counts as one operand.
    def regroup_operators_and_calls!(node)
      return Chain.group(parts(node)).tap { |grouped| grouped.field = node.field } if chain?(node)

      node.children.map! { |child| child.named? ? regroup_operators_and_calls!(child) : child }
      node
    end

    # Return whether the node is an operator or a call that the grammar may
    # have grouped wrongly.
    def chain?(node)
      case node.type
      when "infix_expression" then true
      when "application_expression" then !method_call?(node)
      when "prefixed_expression" then node.named_children.first&.type == "prefix_op"
      else false
      end
    end

    # Return whether the call is a method call, with its argument in brackets
    # right after a name, as in `f(x)`. F# only reads the brackets this way after a
    # name, so `f (a)(b)` is `f a b`, although the grammar reads it as
    # `f (a(b))`.
    def method_call?(call) = bracketed?(call) && call.named_children.first.type != "paren_expression"

    # Return whether the call's argument is in brackets that belong to the call.
    def bracketed?(call) = call.children.any? { |child| child.type == "(" }

    # Return the operands and operators of a chain, in source order.
    def parts(node)
      return [regroup_operators_and_calls!(node)] unless chain?(node)

      children = node.named_children.each { |child| child.field = nil }
      case node.type
      when "infix_expression" then [*parts(children[0]), Chain::Operator.new(:infix, children[1]), *parts(children[2])]
      when "prefixed_expression" then [Chain::Operator.new(:prefix, children[0]), *parts(children[1])]
      else [*parts(children[0]), *(bracketed?(node) ? [regroup_operators_and_calls!(children[1])] : parts(children[1]))]
      end
    end

    ### Matches and union types ###

    # Drop the `|` between the cases of a match, a union type or an enum,
    # because the first one is optional.
    # type Shape = | Circle | Square  ->  type Shape = Circle | Square
    def drop_bars_between_match_union_and_enum_cases!
      each_node(tree) do |node, _|
        node.children.reject! { |child| child.type == "|" } if ["rules", "union_type_cases", "enum_type_cases"].include?(node.type)
      end
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that representation/spec.rb
    # can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      # Mark the name of a module or a namespace as a `module_name`.
      # module Shop.Counter
      captured(tree, "[(named_module name: (long_identifier) @name) (namespace name: (long_identifier) @name)]").each do |name|
        name.type = "module_name"
      end

      # Write a name with no dots as the name itself.
      unwrap(tree, "(long_identifier)")

      # Mark `_` as a `wildcard_pattern`, because it names nothing.
      # member _.Area = 1
      each_node(tree) { |node, _| node.type = "wildcard_pattern" if node.type == "identifier" && node.text == "_" }
      write_functions_with_a_return_type_as_functions!
      mark_single_name_patterns_as_named_patterns!
    end

    # Write each function with a return type as a function. The grammar
    # sometimes reads one as a pattern, with the return type on the last
    # parameter.
    #
    # e.g. The grammar reads:
    # let add (a: int) (b: int): int = a + b
    #
    # as the pattern `add (a: int) ((b: int): int)`, and we convert it into
    # the function `add` with the parameters `(a: int)` and `(b: int)` and
    # the return type `int`.
    def write_functions_with_a_return_type_as_functions!
      find_all(tree, "(function_or_value_defn (value_declaration_left) @left)").each do |match|
        definition = match.node
        left = match[:left]
        head = left.named_children.first
        next unless head.type == "identifier_pattern"

        name, *parameters, typed = head.named_children
        next unless typed&.type == "typed_pattern" && name.type == "long_identifier_or_op" && name.children.one?

        parameter, type = typed.named_children
        function = build(:function_declaration_left, name.children.first, build(:argument_patterns, *parameters, parameter))
        definition.children[definition.children.index(left), 1] = [function, token(":"), type]
      end
    end

    # Mark a pattern that is one name as a `named_pattern`, as F#'s parser
    # does. It does this for a name that doesn't start with an upper case
    # letter, because F# reads an upper case name in a pattern as a union
    # case or a constant, such as `None`. The whole left of a `let` is always
    # a new name.
    #
    # In `let f (Some x) = x`, `x` is a named_pattern, and `Some` isn't.
    def mark_single_name_patterns_as_named_patterns!
      # Write a parameter that is a bare name as a pattern, as it is in brackets.
      # let f x = x  ->  let f (x) = x
      each_node(tree) do |node, _|
        next unless node.type == "argument_patterns"

        node.children.map! do |child|
          child.type == "identifier" ? build(:identifier_pattern, build(:long_identifier_or_op, child)) : child
        end
      end
      captured(tree, "(value_declaration_left (identifier_pattern) @name)").each do |pattern|
        name = single_name(pattern)
        pattern.type = "named_pattern" if name
        pattern.children = [name] if name
      end
      transform(tree, "(identifier_pattern) @pattern") do |match|
        name = single_name(match.node)
        build(:named_pattern, name) if name&.text&.match?(/\A[^A-Z]/)
      end
    end

    # Return the name in a pattern that is only one name, or nil.
    def single_name(pattern)
      path = pattern.children.first
      return nil unless pattern.children.one? && path.type == "long_identifier_or_op" && path.children.one?

      path.children.first if path.children.first.type == "identifier"
    end

    # This class groups the operands and operators of a chain by F#'s rules,
    # with precedence climbing. Each part is an operand (a node) or an Operator.
    class Chain
      include Rosetta::Engine::TreeHelpers

      Operator = Struct.new(:position, :node)

      # List how tightly each infix operator binds, by F#'s rules, and whether
      # a chain of them groups from the right. F# reads an operator by its first
      # characters, so `>>` binds like `|>`, and `**` binds tighter than `*`.
      #
      # The grammar reads `<-` and `:=` as operators, and the cases of a match
      # written on one line as `|` and `->` operators, so these bind loosest.
      INFIX = [
        [/\A(<-|:=|\||->)\z/, 0, :left],
        [/\A(\|\||or)\z/, 1, :left],
        [/\A&&?\z/, 2, :left],
        [/\A::\z/, 5, :right],
        [/\A\*\*/, 8, :right],
        [%r{\A[*/%]}, 7, :left],
        [/\A[-+]/, 6, :left],
        [/\A[\^@]/, 4, :right],
        [//, 3, :left]
      ].freeze

      # These prefix operators bind tighter than a function call, and the
      # others (such as `-`) bind looser.
      #
      # !f x  ->  (!f) x
      # -f x  ->  -(f x)
      TIGHT_PREFIX = /\A[!~?]/

      def self.group(parts) = new(parts).expression

      def initialize(parts)
        @parts = parts
      end

      # Read the operators that bind at least as tightly as `tightest`.
      def expression(tightest = 0)
        left = prefixed
        while (op = upcoming(:infix))
          _, strength, grouping = INFIX.find { |pattern, _, _| op.text.delete_prefix(".").match?(pattern) }
          break if strength < tightest

          @parts.shift
          left = build(:infix_expression, left, op, expression(grouping == :right ? strength : strength + 1))
        end
        left
      end

      private
      # Read a prefix operator that binds looser than a call, such as `-`,
      # and the calls after it.
      def prefixed
        op = upcoming(:prefix)
        return calls if op.nil? || op.text.match?(TIGHT_PREFIX)

        @parts.shift
        build(:prefixed_expression, op, prefixed)
      end

      # Read a function and the arguments after it.
      def calls
        function = argument
        function = build(:application_expression, function, argument) while @parts.any? && !upcoming(:infix)
        function
      end

      # Read one operand, with any prefix operators before it.
      def argument
        part = @parts.shift
        part.is_a?(Operator) ? build(:prefixed_expression, part.node, argument) : part
      end

      # Return the next part's node if it is an operator in this position.
      def upcoming(position) = @parts.first.is_a?(Operator) && @parts.first.position == position ? @parts.first.node : nil
    end
  end
end
