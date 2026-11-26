module Representer
  module Languages
    # Every step of exercism/fsharp-representer is a rule here. The old
    # representer removed comments and `open` lines, renamed the names the
    # student chose, and let Fantomas print the code. Here the syntax tree
    # makes layout irrelevant, so the printing step has no equivalent.
    class FSharp < Language
      tracks "fsharp"
      version 4
      grammar "fsharp"
      extensions ".fs", ".fsx"

      names :identifier

      # The grammar keeps the text of these only as a single node, so each is
      # kept as one leaf. A plain or interpolated string is a node with its
      # text between the quotes, which the rules below turn into a value.
      text_nodes :float, :verbatim_string, :triple_quoted_string, :bytearray
      text_between_children :string, :format_string

      ### Drop ###

      # RemoveComments (including XML documentation) and RemoveImports.
      drop "[(line_comment) (block_comment) (xml_doc) (import_decl)]"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", "[|", "|]", ";", ",", "let", "module", "namespace", "type", "fun",
        "function", "if", "then", "else", "elif", "match"

      ### Rewrite ###

      # The grammar writes an operator as a leaf in some places and as a node
      # with one token in others. Both become a leaf.
      rewrite "(infix_op) @op",
        where: ->(match) { match.node.children.size == 1 && match.node.children.first.leaf? } do |match|
        leaf(:infix_op, match.node.children.first.type)
      end

      # `f (x)` is `f x`, and `(f x)` is `f x`. The grammar ignores operator
      # precedence (it reads `a + b * c` as `(a + b) * c`), so brackets around
      # an operator expression stay, to keep those two apart.
      rewrite "(paren_expression) @paren",
        where: ->(match) { FSharp.groups_one_thing?(match.node) } do |match|
        match.node.named_children.first
      end
      unwrap :paren_pattern

      # The grammar writes a lone name as a long identifier in some places and
      # inside another node in others. A single name has one spelling.
      rewrite "(long_identifier_or_op (long_identifier (identifier) @name)) @outer",
        where: ->(match) { match.node.children.size == 1 && match.node.children.first.children.size == 1 } do |match|
        build(:long_identifier_or_op, match[:name])
      end

      # `let f (x) = ...` is `let f x = ...`.
      rewrite "(argument_patterns) @patterns" do |match|
        changed = false
        match.node.children.map! do |child|
          name = FSharp.single_name(child)
          next child unless name

          changed = true
          build(:long_identifier, name)
        end
        changed ? match.node : nil
      end

      # A string is its value, so "a\n" is the same however it is written.
      rewrite "(string) @string" do |match|
        parts = match.node.children
        next nil unless parts.all? { |part| %w[fragment "].include?(part.type) }

        literal(parts.select { |part| part.type == "fragment" }.map { |part| FSharp.decode_escapes(part.text) }.join)
      end
      rewrite "(verbatim_string /\\A@\"/) @string" do |match|
        text = match.node.text
        literal(text[2..-2].gsub('""', '"'))
      end
      rewrite "(triple_quoted_string /\\A\"\"\"/) @string" do |match|
        literal(match.node.text[3..-4])
      end

      ### Rename and keep ###

      # Variables and parameters. A lower case name in a pattern is a
      # variable. An upper case one (`Some x`, `None`) is a union case or a
      # constant, which the solution doesn't define there.
      rename "(identifier_pattern (long_identifier_or_op (identifier /\\A[a-z_]/) @name))"
      rename "(value_declaration_left (identifier_pattern (long_identifier_or_op (identifier) @name)))"
      rename "(argument_patterns (long_identifier (identifier) @name)*)"
      rename "(function_declaration_left (identifier) @name)"
      rename "(type_check_pattern (identifier) @name)"
      rename "(type_argument (identifier) @name)"
      rename "(property_or_ident instance: (identifier) @name)"

      # Modules, types, union cases, record fields and members can be reached
      # as `Name.member`.
      rename_member "(named_module name: (long_identifier (identifier) @name))"
      rename_member "(module_defn (identifier) @name)"
      rename_member "(type_name type_name: [(identifier) @name (long_identifier (identifier) @name)])"
      rename_member "(union_type_case (identifier) @name)"
      rename_member "(union_type_field (identifier) @name)"
      rename_member "(record_field (identifier) @name)"
      rename_member "(exception_definition exception_name: (long_identifier (identifier) @name))"
      rename_member "(method_or_prop_defn name: (property_or_ident method: (identifier) @name))"
      rename_member "(method_or_prop_defn name: (property_or_ident !instance (identifier) @name))"
      rename_member "(member_signature (identifier) @name)"
      rename_member <<~PATTERN
        (module_defn block: (declaration_expression
          (function_or_value_defn (function_declaration_left (identifier) @name))))
      PATTERN
      rename_member <<~PATTERN
        (module_defn block: (declaration_expression
          (function_or_value_defn (value_declaration_left (identifier_pattern (long_identifier_or_op (identifier) @name))))))
      PATTERN

      # A name after a dot refers to some value's member, or to a name in
      # another module.
      member "(long_identifier \".\" (identifier)* @name)"
      member "(dot_expression field: (long_identifier_or_op (identifier) @name))"
      member "(field_initializer field: (long_identifier (identifier) @name))"

      keep "_", "main", "ToString", "Equals", "GetHashCode", "CompareTo", "Dispose", "GetEnumerator", "MoveNext",
        "Current", "Item", "Some", "None", "Ok", "Error"

      library_names File.join(__dir__, "library_names", "fsharp.txt")

      # Whether brackets group one thing that isn't an operator expression.
      def self.groups_one_thing?(paren)
        paren.named_children.size == 1 && paren.named_children.first.type != "infix_expression"
      end

      # The name in an `identifier_pattern` that holds only a name, or nil.
      def self.single_name(pattern)
        return nil unless pattern.type == "identifier_pattern" && pattern.children.size == 1

        path = pattern.children.first
        name = path.children.first
        path.type == "long_identifier_or_op" && path.children.size == 1 && name.type == "identifier" ? name : nil
      end

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "b" => "\b", "a" => "\a", "f" => "\f", "v" => "\v", "0" => "\0",
        "\\" => "\\", "\"" => "\"", "'" => "'"
      }.freeze

      # Decodes the escapes in a string. One not listed here keeps its source
      # text, so two different strings can never get the same value.
      def self.decode_escapes(text)
        text.gsub(/\\(?:u([0-9a-fA-F]{4})|U([0-9a-fA-F]{8})|x([0-9a-fA-F]{2})|(.))/m) do |escape|
          hex = Regexp.last_match(1) || Regexp.last_match(2) || Regexp.last_match(3)
          if hex
            value = hex.to_i(16)
            value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
          else
            ESCAPES.fetch(Regexp.last_match(4), escape)
          end
        end
      end
    end
  end
end
