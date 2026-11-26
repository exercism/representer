# What this class does to a Rust solution's code to make its representation:
#
# - Drops comments, doc comments, empty statements, `use` declarations and
#   `extern crate`.
# - Drops punctuation and keywords that the tree already shows, every `;`
#   outside arrays and macros, and brackets that only group.
# - Writes `x = y;` as a final `x = y`, as an assignment's value is always
#   `()`.
# - Writes a match arm's `{ y }` as `y`, and `{}` as `()`.
# - Writes numbers as their values (`1_000` is `1000`, `0x1F` is `31`,
#   `1.50` is `1.5`), keeping any type suffix.
# - Writes `Foo { x }` as `Foo { x: x }`, and a string as its value.
# - Sorts the items of a file, impl, trait or module by kind and size.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, the members of the exercise's stub,
#   and the language's library names.
# - Also keeps `main`, `Some`, `None`, `Ok`, `Err`, `self`, `Self` and the
#   standard traits' associated types.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # Every step of exercism/rust-representer is a rule here. Each rule's
    # comment says which step it replaces.
    class Rust < Language
      tracks "rust"
      version 7
      grammar "rust"
      extensions ".rs"

      names :identifier, :field_identifier, :type_identifier, :shorthand_field_identifier

      # The order of top-level items, and then of the items in an impl, a
      # trait or a module. Items of the same kind are sorted by size, largest
      # first.
      ITEM_ORDER = {
        "mod_item" => 1, "const_item" => 2, "static_item" => 2,
        "type_item" => 3, "struct_item" => 4, "enum_item" => 4, "union_item" => 4, "trait_item" => 5, "impl_item" => 6,
        "function_item" => 7
      }.freeze
      MEMBER_ORDER = {
        "associated_type" => 0, "type_item" => 0, "const_item" => 1, "function_signature_item" => 2, "function_item" => 2
      }.freeze

      ### Drop ###

      # IgnoreComments, IgnoreDocComments
      drop "[(line_comment) (block_comment) (empty_statement)]"

      # `use` and `extern crate` only make names available.
      drop "[(use_declaration) (extern_crate_declaration)]"

      # The node types already say what these tokens say. A ";" is only
      # meaningful in `[x; 3]` and in a macro's tokens, so a rule below
      # removes the others.
      drop_tokens "(", ")", "{", "}", "[", "]", ",", "|", "=>", "fn", "let", "struct", "enum", "impl", "trait", "mod",
        "use", "type", "const", "static", "if", "else", "while", "loop", "match",
        "return", "break", "continue", "for", "in", "where", "union"

      # A macro's tokens have no syntax tree, so every token in them counts:
      # `vec![a - 1]` and `vec![a, -1]` differ only by the comma.
      MACRO_TOKENS = %w[token_tree token_tree_pattern delim_token_tree token_repetition token_repetition_pattern].freeze
      MACRO_TOKENS.each { |type| keep_tokens_in type, *dropped_tokens }

      ### Rewrite ###

      rewrite '(_ ";")', where: ->(match) { !["array_expression", *MACRO_TOKENS].include?(match.node.type) } do |match|
        # The pattern also matches a leaf whose text is ";", such as the
        # contents of the string ";", which has no tokens to remove. The
        # block returns nil when it removes nothing, so the rule can't keep
        # matching its own output.
        match.node if match.node.children.reject! { |child| !child.named? && child.type == ";" }
      end

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # An assignment's value is always `()`, so `x = y;` is the same as a
      # final `x = y` without the semicolon.
      rewrite "(expression_statement [(assignment_expression) (compound_assignment_expr)] @assignment)", "@assignment"

      # `x => {}` is `x => ()`.
      rewrite "(match_arm value: (block) @block)", where: ->(match) { match[:block].children.empty? } do |match|
        match.node.replace_child(match[:block], build(:unit_expression))
        match.node
      end

      # `x => { y }` is `x => y`.
      rewrite "(match_arm value: (block) @block)",
        where: ->(match) { match[:block].children.size == 1 && match[:block].children.first.named? } do |match|
        inner = match[:block].children.first
        inner = inner.named_children.first if inner.type == "expression_statement" && inner.named_children.size == 1
        match.node.replace_child(match[:block], inner)
        match.node
      end

      # Numbers are their values: `1_000` is `1000`, `0x1F` is `31`, and
      # `1.50` is `1.5`. A type suffix stays, as in `1000u32`.
      numbers :integer_literal do |text|
        digits, suffix = text.match(/\A(.*?)_?([iu](?:8|16|32|64|128|size))?\z/).captures
        Engine::Numbers.integer(digits)&.then { |value| "#{value}#{suffix}" }
      end
      numbers :float_literal do |text|
        digits, suffix = text.match(/\A(.*?)_?(f32|f64)?\z/).captures
        Engine::Numbers.decimal(digits)&.then { |value| "#{Engine::Numbers.write_decimal(value)}#{suffix}" }
      end

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
