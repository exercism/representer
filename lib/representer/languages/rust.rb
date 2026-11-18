module Representer
  module Languages
    # Every step of exercism/rust-representer is a rule here. Each rule's
    # comment says which step it replaces.
    class Rust < Language
      tracks "rust"
      version 3
      grammar "rust"
      extensions ".rs"

      names :identifier, :field_identifier, :type_identifier, :shorthand_field_identifier

      # The order of top-level items, and then of the items in an impl, a
      # trait or a module. Items of the same kind are sorted by size, largest
      # first.
      ITEM_ORDER = {
        "use_declaration" => 0, "extern_crate_declaration" => 0, "mod_item" => 1, "const_item" => 2, "static_item" => 2,
        "type_item" => 3, "struct_item" => 4, "enum_item" => 4, "union_item" => 4, "trait_item" => 5, "impl_item" => 6,
        "function_item" => 7
      }.freeze
      MEMBER_ORDER = {
        "associated_type" => 0, "type_item" => 0, "const_item" => 1, "function_signature_item" => 2, "function_item" => 2
      }.freeze

      ### Drop ###

      # IgnoreComments, IgnoreDocComments
      drop "[(line_comment) (block_comment) (empty_statement)]"

      # The node types already say what these tokens say. A ";" is only
      # meaningful in `[x; 3]` and in a macro's tokens, so a rule below
      # removes the others.
      drop_tokens "(", ")", "{", "}", "[", "]", ",", "|", "=>", "fn", "let", "struct", "enum", "impl", "trait", "mod",
        "use", "type", "const", "static", "if", "else", "while", "loop", "match"

      ### Rewrite ###

      rewrite '(_ ";")', where: ->(match) { !%w[array_expression token_tree].include?(match.node.type) } do |match|
        match.node.children.reject! { |child| !child.named? && child.type == ";" }
        match.node
      end

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # `Foo { x }` is `Foo { x: x }`, in values and in patterns.
      rewrite "(shorthand_field_initializer (identifier) @name)" do |match|
        build(:field_initializer, { field: leaf(:field_identifier, match[:name].text) }, token(":"), { value: match[:name] })
      end
      rewrite "(field_pattern name: (shorthand_field_identifier) @name)",
        where: ->(match) { match.node.children.size == 1 } do |match|
        build(:field_pattern, { name: leaf(:field_identifier, match[:name].text) }, token(":"),
          { pattern: leaf(:identifier, match[:name].text) })
      end

      # SortItems: items are sorted, and an attribute stays with its item.
      # The old representer sorted by name, so two solutions that named
      # things differently could get different representations.
      rewrite "[(source_file) @items (declaration_list) @items]" do |match|
        organised = Rust.organise(match.node.children, match.node.type == "source_file" ? ITEM_ORDER : MEMBER_ORDER)
        organised.map(&:inspect) == match.node.children.map(&:inspect) ? nil : build(match.node.type, *organised)
      end

      # A string is its value: the quotes and a raw string's markers don't
      # matter. A byte string is a different type, so it keeps a marker.
      rewrite "[(string_literal) @string (raw_string_literal) @string]" do |match|
        parts = match.node.children.select(&:named?)
        next nil unless parts.all? { |part| STRING_PARTS.include?(part.type) }

        value = parts.map { |part| part.type == "escape_sequence" ? Rust.decode(part.text) : part.text }.join
        value = value.gsub("\r\n", "\n") if match.node.type == "string_literal"
        string = literal(value)
        match.node.children.first&.text&.match?(/\A[bc]/) ? build(:byte_string, string) : string
      end

      ### Rename and keep ###

      # NormalizeIdentifiers. Every identifier the student defines is renamed.
      rename "[(let_declaration pattern: (identifier) @name) (parameter pattern: (identifier) @name)]"
      rename "[(for_expression pattern: (identifier) @name) (let_condition pattern: (identifier) @name)]"
      rename "(closure_parameters (identifier)* @name)"
      rename "[(tuple_pattern (identifier)* @name) (tuple_struct_pattern (identifier)* @name)]"
      rename "[(slice_pattern (identifier)* @name) (match_pattern (identifier) @name) (captured_pattern (identifier) @name)]"
      rename "[(mut_pattern (identifier) @name) (ref_pattern (identifier) @name) (reference_pattern (identifier) @name)]"
      rename "(field_pattern pattern: (identifier) @name)"
      rename "[(const_item name: (identifier) @name) (static_item name: (identifier) @name) (mod_item name: (identifier) @name)]"
      rename "[(function_item name: (identifier) @name) (const_parameter name: (identifier) @name)]"
      rename "[(type_parameter name: (type_identifier) @name) (type_item name: (type_identifier) @name)]"
      rename "(lifetime_parameter name: (lifetime (identifier) @name))"
      rename "[(struct_item name: (type_identifier) @name) (enum_item name: (type_identifier) @name)]"
      rename "[(union_item name: (type_identifier) @name) (trait_item name: (type_identifier) @name)]"

      # Methods, fields and enum variants can be reached from other code
      # (`value.name`, `Type::name`), so they are renamed there too.
      rename_member "(declaration_list (function_item name: (identifier) @name)*)"
      rename_member "(declaration_list (function_signature_item name: (identifier) @name)*)"
      rename_member "[(field_declaration name: (field_identifier) @name) (enum_variant name: (identifier) @name)]"

      # A name after a dot or `::` refers to some value's method or field, or
      # to a name in another module.
      member "[(field_expression field: (field_identifier) @name) (field_initializer field: (field_identifier) @name)]"
      member "[(field_pattern name: (field_identifier) @name) (scoped_identifier name: (identifier) @name)]"
      member "(scoped_type_identifier name: (type_identifier) @name)"

      keep "main", "Some", "None", "Ok", "Err", "self", "Self"

      # Associated types that the standard library's traits fix.
      keep "Output", "Item", "Target", "Error", "IntoIter"

      library_names File.join(__dir__, "library_names", "rust.txt")

      STRING_PARTS = %w[string_content escape_sequence].freeze
      ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "\\" => "\\", "0" => "\0", "\"" => "\"", "'" => "'" }.freeze

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value. A byte escape above
      # 127 isn't a character on its own, so it stays as written.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au\{([0-9a-fA-F_]{1,6})\}\z/
          value = Regexp.last_match(1).delete("_").to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        when /\Ax([0-7][0-9a-fA-F])\z/ then Regexp.last_match(1).to_i(16).chr
        else ESCAPES.fetch(code, escape)
        end
      end

      ### Helpers for the rules above ###

      # Sorts the items, keeping each attribute with the item after it.
      # Inner attributes (#![...]) stay first.
      def self.organise(children, order)
        head, rest = children.partition { |child| child.type == "inner_attribute_item" }
        groups = rest.slice_after { |child| child.type != "attribute_item" }.to_a
        sorted = groups.each_with_index.sort_by do |group, index|
          item = group.last
          [order.fetch(item.type, order.values.max + 1), -size(item), key(item), index]
        end
        head + sorted.flat_map(&:first)
      end

      def self.size(node)
        count = 0
        node.each_descendant { count += 1 }
        count
      end

      # The node's text with every name left out, to put equal-sized items in
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
