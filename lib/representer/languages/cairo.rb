module Representer
  module Languages
    # Cairo has no old representer, so there are no upstream tests to port.
    # The grammar is starkware-libs/tree-sitter-cairo (Apache-2.0).
    #
    # The class removes comments and formatting, and renames the names that
    # the solution defines, apart from the names that a library, the tests
    # or the language give a meaning. Cairo's syntax is close to Rust's, so
    # the rules follow the Rust class.
    class Cairo < Language
      tracks "cairo"
      version 2
      grammar "cairo"
      extensions ".cairo"

      # A string and a short string (`'abc'`) hold their text in tokens that
      # the tree doesn't show, so each is kept as a leaf with its whole text.
      text_nodes :string_literal, :shortstring_literal

      names :identifier, :field_identifier, :type_identifier, :shorthand_field_identifier

      ### Drop ###

      drop "[(line_comment) (empty_statement)]"

      # The node types already say what these tokens say. A ";" is dropped
      # below, because a statement and a final expression are different nodes.
      drop_tokens "(", ")", "{", "}", "[", "]", ",", "fn", "let", "struct", "enum", "impl", "trait", "mod", "use",
        "type", "const", "if", "else", "while", "loop", "match", "return", "break", "continue", "for", "in", "pub"

      ### Rewrite ###

      rewrite '(_ ";")', where: ->(match) { match.node.type != "token_tree" } do |match|
        match.node.children.reject! { |child| !child.named? && child.type == ";" }
        match.node
      end

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # 1_000 is 1000.
      rewrite "(numeric_literal /_/) @number" do |match|
        leaf(:numeric_literal, match[:number].text.delete("_"))
      end

      # `P { x }` is `P { x: x }`, in values and in patterns.
      rewrite "(shorthand_field_initializer (identifier) @name)" do |match|
        build(:field_initializer, { field: leaf(:field_identifier, match[:name].text) }, token(":"), { value: match[:name] })
      end
      rewrite "(field_pattern name: (shorthand_field_identifier) @name)",
        where: ->(match) { match.node.children.size == 1 } do |match|
        build(:field_pattern, { name: leaf(:field_identifier, match[:name].text) }, token(":"),
          { pattern: leaf(:identifier, match[:name].text) })
      end

      ### Rename and keep ###

      rename "[(let_declaration pattern: (identifier) @name) (parameter pattern: (identifier) @name)]"
      rename "[(for_expression pattern: (identifier) @name) (let_condition pattern: (identifier) @name)]"
      rename "(closure_parameters (identifier)* @name)"
      rename "[(tuple_pattern (identifier)* @name) (tuple_enum_pattern (identifier)* @name)]"
      rename "[(slice_pattern (identifier)* @name) (match_pattern (identifier) @name)]"
      rename "[(mut_pattern (identifier) @name) (ref_pattern (identifier) @name) (field_pattern pattern: (identifier) @name)]"
      rename "[(const_item name: (identifier) @name) (mod_item name: (identifier) @name)]"
      rename "[(struct_item name: (type_identifier) @name) (enum_item name: (type_identifier) @name)]"
      rename "[(trait_item name: (type_identifier) @name) (type_item name: (type_identifier) @name)]"
      rename "(type_parameters (type_identifier)* @name)"
      rename "(impl_item (identifier) @name)"

      # Functions, fields and enum variants can be reached from other code
      # (`value.name`, `Type::name`), so they are renamed there too.
      rename_member "(function name: (identifier) @name)"
      rename_member "[(field_declaration name: (field_identifier) @name) (enum_variant variant: (identifier) @name)]"

      # A name after a dot or `::` refers to some value's method or field, or
      # to a name in another module.
      member "[(field_expression field: (field_identifier) @name) (field_initializer field: (field_identifier) @name)]"
      member "[(field_pattern name: (field_identifier) @name) (scoped_identifier name: (identifier) @name)]"
      member "(scoped_type_identifier name: (type_identifier) @name)"

      keep "main", "Some", "None", "Ok", "Err", "self", "Self"

      library_names File.join(__dir__, "library_names", "cairo.txt")
    end
  end
end
