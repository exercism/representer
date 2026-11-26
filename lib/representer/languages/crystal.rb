module Representer
  module Languages
    # Every step of exercism/crystal-representer is a rule here. The old
    # representer parsed the code with the Crystal compiler, renamed the names
    # the student chose, sorted the methods of each class and module by name,
    # and printed the tree back as code. The printing step has no equivalent
    # here, because the tree has no layout.
    class Crystal < Language
      tracks "crystal"
      version 6
      grammar "crystal"
      extensions ".cr"

      names :identifier, :constant, :instance_var, :class_var

      # The grammar gives `Foo::Bar` a constant node that has only the `::`
      # as children, so a constant is kept as a leaf with its whole text. A
      # rule below splits the ones with a path.
      text_nodes :constant

      ### Drop ###

      # The old representer dropped comments, because they aren't in the
      # compiler's tree.
      drop "(comment)"

      # `foo()` is `foo`.
      drop "(argument_list)", where: ->(match) { match.node.children.empty? }

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", "|", ":", "def", "class", "module", "struct", "enum",
        "if", "unless", "elsif", "else", "while", "until", "then", "do", "end", "begin", "return", "case", "when",
        "include", "extend", "alias",
        "require"

      ### Rewrite ###

      # `foo()` and `foo` are the same call.
      rewrite "(call !receiver method: (identifier) @method) @call",
        where: ->(match) { match.node.children.size == 1 } do |match|
        match[:method]
      end

      # (x) is x. A body is also an `expressions` node, so only the
      # `expressions` nodes that sit in another position are unwrapped.
      rewrite "(expressions (_) @inner)",
        where: ->(match) { match.node.field != "body" && match.node.named_children.size == 1 } do |match|
        match[:inner]
      end

      # A modifier is the same as the block form: `x if y` is `if y; x; end`.
      rewrite "(modifier_if then: (_) @body cond: (_) @cond)", "(if cond: @cond then: (then @body))"
      rewrite "(modifier_unless then: (_) @body cond: (_) @cond)", "(unless cond: @cond then: (then @body))"

      # `:"abc"` is `:abc`.
      rewrite '(symbol ":\"") @symbol' do |match|
        build(:symbol, *match.node.children.reject { |child| %w[:" "].include?(child.type) })
      end

      # `&.name` is a call to `name`. The grammar writes the dot as part of
      # the name.
      rewrite "(implicit_object_call method: (identifier /\\A\\./) @method)" do |match|
        match.node.replace_child(match[:method], leaf(:identifier, match[:method].text.delete_prefix(".")))
        match.node
      end

      # 1_000 is 1000.
      rewrite "[(integer /\\d_\\d/) @number (float /\\d_\\d/) @number]" do |match|
        leaf(match[:number].type, match[:number].text.gsub(/(?<=\d)_(?=\d)/, ""))
      end

      # `Foo::Bar` is a path of constants, and the `::` before a name is how
      # the grammar writes a name inside another.
      rewrite "(constant /::/) @path" do |match|
        parts = match.node.text.split("::", -1)
        children = parts.flat_map { |part| part.empty? ? [] : [leaf(:constant, part), token("::")] }
        children.pop unless match.node.text.end_with?("::")
        children.unshift(token("::")) if match.node.text.start_with?("::")
        build(:path, *children)
      end

      # A string is its value: "a", %q(a) and %w(a b)'s parts are the same.
      # Strings with interpolation keep their structure, with each literal part
      # as one value. The rule needs a quote or a literal part, so it doesn't
      # match its own output.
      rewrite "(string) @string", where: ->(match) { Crystal.plain_string?(match.node) } do |match|
        pieces = Crystal.string_parts(match.node.children.select(&:named?))
        next literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Engine::Node)

        build(:string, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end

      # Methods in a class, module or struct are sorted, largest first. Two
      # solutions that define the same methods in a different order get the
      # same representation. The old representer sorted by name, so two
      # solutions that named things differently could get different
      # representations.
      rewrite <<~PATTERN do |match|
        [(class_def body: (expressions) @body) (module_def body: (expressions) @body)
         (struct_def body: (expressions) @body)]
      PATTERN
        body = match[:body]
        sorted = Crystal.sort_methods(body.children)
        next nil if sorted.map(&:object_id) == body.children.map(&:object_id)

        body.children = sorted
        match.node
      end

      ### Rename and keep ###

      # Local variables, parameters, instance variables and type variables.
      rename "[(param name: (identifier) @name) (splat_param name: (identifier) @name)]"
      rename "[(double_splat_param name: (identifier) @name) (block_param name: (identifier) @name)]"
      rename "[(assign lhs: (identifier)* @name) (op_assign lhs: (identifier) @name)]"
      rename "[(type_declaration var: (identifier) @name) (rescue variable: (identifier) @name)]"
      rename "[(instance_var) @name (class_var) @name]"
      rename "[(generic_type params: (param_list (constant)* @name)) (forall (constant)* @name)]"

      # Methods, types and constants.
      rename_member "[(method_def name: (identifier) @name) (abstract_method_def name: (identifier) @name)]"
      rename_member "(macro_def name: (identifier) @name)"
      rename_member "[(class_def name: (constant) @name) (struct_def name: (constant) @name)]"
      rename_member "[(module_def name: (constant) @name) (enum_def name: (constant) @name)]"
      rename_member "[(class_def name: (generic_type (constant) @name)) (struct_def name: (generic_type (constant) @name))]"
      rename_member "(module_def name: (generic_type (constant) @name))"
      rename_member "[(class_def name: (path (constant)* @name)) (module_def name: (path (constant)* @name))]"
      rename_member "[(alias name: (constant) @name) (const_assign lhs: (constant) @name)]"
      rename_member "(enum_def body: (expressions (constant)* @name))"
      rename_member "(enum_def body: (expressions (const_assign lhs: (constant) @name)*))"

      # property, getter and setter (and their class_ forms) define methods.
      rename_member <<~'PATTERN'
        (call !receiver
          method: (identifier /\A(class_)?(property|getter|setter)[?!]?\z/)
          arguments: (argument_list (identifier)* @name))
      PATTERN
      rename_member <<~'PATTERN'
        (call !receiver
          method: (identifier /\A(class_)?(property|getter|setter)[?!]?\z/)
          arguments: (argument_list (type_declaration var: (identifier) @name)*))
      PATTERN

      # Names after a dot or `::` refer to some object's method or type.
      member "(call receiver: (_) method: (identifier) @name)"
      member "(implicit_object_call method: (identifier) @name)"
      member "(path \"::\" (constant)* @name)"

      # Callers pass arguments by name, so the name stays unless the solution
      # defines a method with it.
      member "(named_expr name: (identifier) @name)"

      # Methods that Crystal itself calls.
      keep "initialize", "to_s", "inspect", "to_a", "to_h", "to_i", "to_f", "to_json", "to_proc", "each", "size", "hash",
        "call", "succ", "clone", "dup", "finalize", "method_missing",
        "included", "extended", "inherited", "self", "main"

      library_names File.join(__dir__, "library_names", "crystal.txt")

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "e" => "\e", "a" => "\a", "b" => "\b", "f" => "\f", "v" => "\v",
        "0" => "\0", "\\" => "\\", "\"" => "\"", "'" => "'", "#" => "#"
      }.freeze

      STRING_PARTS = %w[" literal_content escape_sequence interpolation].freeze

      # Whether a string node is still in the grammar's form: only a quote,
      # text, escapes and interpolations, with at least a quote or some text.
      def self.plain_string?(node)
        node.children.all? { |child| STRING_PARTS.include?(child.type) } &&
          node.children.any? { |child| %w[" literal_content escape_sequence].include?(child.type) }
      end

      # Joins a string's literal parts into values, decoding escapes, and keeps
      # interpolations as they are. Returns a list of Strings and nodes.
      def self.string_parts(parts)
        parts.each_with_object([]) do |part, pieces|
          if part.type == "interpolation"
            pieces << part
            next
          end

          text = part.type == "escape_sequence" ? decode(part.text) : part.text
          pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
        end
      end

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au\{([0-9a-fA-F ]+)\}\z/ then Regexp.last_match(1).split.map { |hex| hex.to_i(16) }.pack("U*")
        when /\Au([0-9a-fA-F]{4})\z/, /\Ax([0-9a-fA-F]{2})\z/ then [Regexp.last_match(1).to_i(16)].pack("U")
        else ESCAPES.fetch(code, escape)
        end
      end

      ### Helpers for the rules above ###

      # Puts the methods of a body in order, each in a place where a method
      # was. A method with a visibility (`private def`) goes with the methods.
      def self.sort_methods(children)
        slots = children.each_index.select { |index| method?(children[index]) }
        return children if slots.size < 2

        sorted = slots.map { |index| children[index] }.each_with_index.sort_by do |node, index|
          [-size(node), key(node), index]
        end.map(&:first)
        result = children.dup
        slots.zip(sorted) { |slot, node| result[slot] = node }
        result
      end

      def self.method?(node)
        node.type == "method_def" || (node.type == "visibility_modifier" && node.children.any? { |child| child.type == "method_def" })
      end

      def self.size(node)
        count = 0
        node.each_descendant { count += 1 }
        count
      end

      # The node's text with every name left out, to put equal-sized methods in
      # an order that doesn't depend on what they are called.
      def self.key(node)
        parts = []
        node.each_descendant do |descendant|
          next unless descendant.leaf?

          parts << (names.key?(descendant.type) ? "" : descendant.text.to_s)
        end
        parts.join(" ")
      end
    end
  end
end
