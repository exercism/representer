# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Crystal's own parser gives.
module Representer::Languages::Crystal::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # def f(x) ... end  ->  (method_def f (param_list (param x)) ...)
    strip_tokens "alias", "begin", "case", "class", "def", "do", "else", "elsif", "end", "enum", "extend", "if",
                 "include", "module", "require", "return", "struct", "then", "unless", "until", "when", "while"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # puts(x)  ->  puts x
    # a.map { |x| x }  ->  (call a map (block (param_list (param x)) x))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", "|", ":"

    INT32 = (-(2**31)...(2**31))
    INT64 = (-(2**63)...(2**63))

    ESCAPES = {
      "n" => "\n",
      "t" => "\t",
      "r" => "\r",
      "e" => "\e",
      "a" => "\a",
      "b" => "\b",
      "f" => "\f",
      "v" => "\v",
      "0" => "\0",
      "\\" => "\\",
      '"' => '"',
      "'" => "'",
      "#" => "#"
    }.freeze

    STRING_PARTS = ['"', "literal_content", "escape_sequence", "interpolation"].freeze

    def call
      tree.tap do
        write_numbers_as_values!
        drop_empty_argument_lists!
        write_calls_without_arguments_as_names!
        unwrap_brackets_that_only_group!
        write_modifiers_as_blocks!
        write_quoted_symbols_as_symbols!
        drop_the_dot_from_implicit_object_calls!
        write_operator_methods_as_operators!
        split_paths_into_constants!
        write_strings_as_their_values!
        list_the_targets_of_a_multiple_assignment!
        mark_the_names_that_types_define!
      end
    end

    private
    ### Numbers ###

    # Write each number as its value. Drop a suffix that names the type the
    # number has anyway: an integer is an Int32 if it fits, or else an
    # Int64, and a decimal is a Float64.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    # 1_i32  ->  1
    # 4400000000_i64  ->  4400000000
    # 2.0_f64  ->  2.0
    def write_numbers_as_values!
      each_node(tree) do |node, _|
        next unless node.leaf?

        node.text = integer(node.text) || node.text if node.type == "integer"
        node.text = float(node.text) || node.text if node.type == "float"
      end
    end

    def integer(text)
      digits, suffix = text.match(/\A(.*?)_?([iu](?:8|16|32|64|128))?\z/).captures
      value = Representer::Engine::Numbers.integer(digits)
      return nil unless value

      default = INT32.cover?(value) ? "i32" : ("i64" if INT64.cover?(value))
      suffix && suffix != default ? "#{value}_#{suffix}" : value.to_s
    end

    def float(text)
      digits, suffix = text.match(/\A(.*?)_?(f32|f64)?\z/).captures
      value = Representer::Engine::Numbers.decimal(digits)
      return nil unless value

      written = Representer::Engine::Numbers.write_decimal(value)
      suffix == "f32" ? "#{written}_f32" : written
    end

    ### Calls and brackets ###

    # Drop the empty brackets of a call.
    # f()  ->  f
    # a.b()  ->  a.b
    def drop_empty_argument_lists!
      each_node(tree) do |node, _|
        node.children.reject! { |child| child.type == "argument_list" && child.named_children.empty? }
      end
    end

    # Write a call with no receiver, arguments or block as its name, because
    # the parser reads `f` and `f()` as the same call.
    # f()  ->  f
    def write_calls_without_arguments_as_names!
      transform(tree, "(call !receiver method: (identifier) @method)") do |match|
        match[:method] if match.node.named_children.one?
      end
    end

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the body of a method, block or class, where a single
    # statement still sits in a list of statements.
    # (1 + 2) * 3  ->  (call (call 1 + 2) * 3)
    def unwrap_brackets_that_only_group!
      transform(tree, "(expressions) @expressions") do |match|
        node = match.node
        node.named_children.first if !node.equal?(tree) && node.field != "body" && node.named_children.one?
      end
    end

    # Write `x if y` as an `if` block, because the parser reads them as the same.
    # puts 1 if a  ->  if a; puts 1; end
    # puts 1 unless a  ->  unless a; puts 1; end
    def write_modifiers_as_blocks!
      transform(tree, "(modifier_if then: (_) @body cond: (_) @cond)", "(if cond: @cond then: (then @body))")
      transform(tree, "(modifier_unless then: (_) @body cond: (_) @cond)", "(unless cond: @cond then: (then @body))")
    end

    # Drop the quotes of a quoted symbol.
    # :"abc"  ->  :abc
    def write_quoted_symbols_as_symbols!
      transform(tree, '(symbol ":\"") @symbol') do |match|
        build(:symbol, *match.node.children.reject { |child| [':"', '"'].include?(child.type) })
      end
    end

    # Drop the dot from the name in `&.name`, because the grammar writes it as
    # part of the name.
    # xs.map(&.size)  ->  (implicit_object_call size)
    def drop_the_dot_from_implicit_object_calls!
      transform(tree, "(implicit_object_call method: (identifier /\\A\\./) @method)") do |match|
        match.node.replace_child(match[:method], leaf(:identifier, match[:method].text.delete_prefix(".")))
        match.node
      end
    end

    # Write an operator called as a method as an operator leaf, because the
    # grammar gives `x.**(2)` the operator as a token and `x ** 2` as a leaf.
    # x.**(2)  ->  x ** 2
    def write_operator_methods_as_operators!
      transform(tree, "(operator) @operator") do |match|
        tokens = match.node.children
        leaf(:operator, tokens.first.type) if tokens.one? && !tokens.first.named?
      end
    end

    # Split a constant with a path into its parts, so each part can be renamed.
    # Foo::Bar  ->  (path (constant Foo) :: (constant Bar))
    # ::Foo  ->  (path :: (constant Foo))
    def split_paths_into_constants!
      transform(tree, "(constant /::/) @path") do |match|
        text = match.node.text
        parts = text.split("::", -1).flat_map { |part| part.empty? ? [] : [leaf(:constant, part), token("::")] }
        parts.pop unless text.end_with?("::")
        parts.unshift(token("::")) if text.start_with?("::")
        build(:path, *parts)
      end
    end

    ### Strings ###

    # Turn each string into its value, and read its escapes. Keep the
    # interpolations, with the text around them as values. Keep any other
    # escape as it is written, so it can't make two different strings the
    # same.
    #
    # %q(a b)  ->  "a b"
    # %w(a b)  ->  ["a", "b"]
    # "aA"  ->  "aA"
    # "a#{b}c"  ->  (string "a" (interpolation b) "c")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        next nil unless match.node.children.all? { |child| STRING_PARTS.include?(child.type) }

        pieces = string_pieces(match.node.named_children)
        next literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Representer::Engine::Node)

        build(:string, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end
    end

    # Join a string's text and escapes into Strings, and keep each
    # interpolation as its node.
    def string_pieces(parts)
      parts.each_with_object([]) do |part, pieces|
        next pieces << part if part.type == "interpolation"

        text = part.type == "escape_sequence" ? escape(part.text) : part.text
        pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
      end
    end

    def escape(text)
      code = text[1..]
      case code
      when /\Au\{([0-9a-fA-F ]+)\}\z/ then Regexp.last_match(1).split.map { |hex| hex.to_i(16) }.pack("U*")
      when /\Au([0-9a-fA-F]{4})\z/, /\Ax([0-9a-fA-F]{2})\z/ then [Regexp.last_match(1).to_i(16)].pack("U")
      else ESCAPES.fetch(code, text)
      end
    end

    ### Names ###

    # Put the names on the left of a multiple assignment in a list of their
    # own, as the parser does, so representation/spec.rb can list them as
    # definitions.
    # a, b = 1, 2  ->  (assign (targets a b) 1 2)
    def list_the_targets_of_a_multiple_assignment!
      each_node(tree) do |node, _|
        next unless node.type == "assign" && node.children.count { |child| child.field == "lhs" } > 1

        first = node.children.index { |child| child.field == "lhs" }
        targets, others = node.children.partition { |child| child.field == "lhs" }
        targets.each { |target| target.field = nil }
        node.children = others.insert(first, build(:targets, *targets).tap { |list| list.field = "lhs" })
      end
    end

    # Give the type variables of a type, and a type's name written as a
    # path, types of their own, so representation/spec.rb can list them as
    # definitions.
    # class Box(T)  ->  (class_def (generic_type Box (type_vars T)) ...)
    # module Shop::Counting  ->  (module_def (type_name Shop :: Counting) ...)
    # enum Color; Red; end  ->  (enum_def Color (enum_body Red))
    def mark_the_names_that_types_define!
      captured(tree, "(generic_type params: (param_list) @name)").each { |vars| vars.type = "type_vars" }
      types = "[(class_def name: (path) @name) (module_def name: (path) @name) (struct_def name: (path) @name) " \
              "(enum_def name: (path) @name)]"
      captured(tree, types).each { |path| path.type = "type_name" }
      captured(tree, "(enum_def body: (expressions) @name)").each { |body| body.type = "enum_body" }
    end
  end
end
