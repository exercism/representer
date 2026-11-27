# What this class does to a Wren solution's code to make its representation:
#
# - Drops comments and imports.
# - Drops punctuation and keywords that the tree already shows, and brackets
#   that only group.
# - Writes a string as its value, keeping interpolations.
# - Writes numbers as their values: every Wren number is a double, so `1.0`
#   is `1`, and `0x1F` is `31`.
# - Writes `if (a) b` as `if (a) { b }`, and the same for loops.
# - Sorts a map's entries when every key is a string.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests and the members of the exercise's stub.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # The old representer (exercism/wren-representer) walked the tree of the
    # Lezer Wren grammar, wrote each token with spaces between them, and
    # replaced class names, method definitions and variables with
    # placeholders, except for the core classes. It sorted the entries of a
    # map literal by key. It didn't replace the name of a method that is
    # called after a dot, so a solution's own method called as `Board.size`
    # kept its name. Here every name that the solution defines is renamed
    # everywhere, the core classes and methods keep their names, and the
    # output is a tree.
    class Wren < Language
      tracks "wren"
      version 8
      grammar "wren"
      extensions ".wren"

      # A raw string `"""..."""` has no children, so it holds its own text.
      text_nodes :raw_string

      names :identifier, :field, :static_field

      ### Drop ###

      drop "[(line_comment) (block_comment)]"

      # Imports only make names available.
      drop "(import_statement)"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "{", "}", "[", "]", ",",
        "class", "construct", "for", "in", "if", "return", "var"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # A string is its value. A string with an interpolation keeps its
      # structure.
      rewrite "(string) @string" do |match|
        parts = match.node.children.select(&:named?)
        next nil unless parts.all? { |part| %w[string_content escape_sequence].include?(part.type) }

        literal(parts.map { |part| part.type == "escape_sequence" ? Wren.decode(part.text) : part.text }.join)
      end
      rewrite "(raw_string) @string" do |match|
        literal(match.node.text.delete_prefix('"""').delete_suffix('"""'))
      end

      # Numbers are their values. Every Wren number is a double, so `1.0` and
      # `1e0` are `1`, `0x1F` is `31`, and `1.50` is `1.5`.
      numbers :number do |text|
        value = Engine::Numbers.integer(text, separator: "", prefixes: { "0x" => 16 }) ||
                Engine::Numbers.decimal(text, separator: "")
        value && Engine::Numbers.write_number(value.to_r)
      end

      # `if (a) b` is `if (a) { b }`, and the same for loops.
      rewrite "[(if_statement) (while_statement) (for_statement)] @statement" do |match|
        Wren.unwrap_blocks(match.node) ? match.node : nil
      end

      # The order of a map's entries doesn't change the map.
      rewrite "(map_literal) @map" do |match|
        Wren.sort_entries(match.node) ? match.node : nil
      end

      ### Rename and keep ###

      rename "(var_statement name: (identifier) @name)"
      rename "(class_definition name: (identifier) @name)"
      rename "(parameter_list (identifier)* @name)"
      rename "(closure_parameter_list (identifier)* @name)"
      rename "(subscript_parameter_list (identifier)* @name)"
      rename "(setter_definition parameter: (identifier) @name)"
      rename "(operator_method parameter: (identifier) @name)"
      rename "(for_statement variable: (identifier) @name)"
      rename "[(field) @name (static_field) @name]"

      # Methods are reached after a dot, so they are renamed there too.
      rename_member "[(getter_definition name: (identifier) @name) (named_method name: (identifier) @name)]"
      rename_member "[(setter_definition name: (identifier) @name) (constructor_definition name: (identifier) @name)]"
      member "(method_call_expression method: (identifier) @name)"

      ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "0" => "\0", "a" => "\a", "b" => "\b", "e" => "\e",
                  "f" => "\f", "v" => "\v", "\\" => "\\", "\"" => "\"", "%" => "%" }.freeze

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au([0-9a-fA-F]{4})\z/, /\AU([0-9a-fA-F]{8})\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        else ESCAPES.fetch(code, escape)
        end
      end

      # Replaces a block with one statement by that statement, in the parts of
      # a statement that hold its body. Returns whether anything changed.
      def self.unwrap_blocks(statement)
        changed = false
        statement.children.each_with_index do |child, index|
          next unless %w[consequence alternative body].include?(child.field) && child.type == "block"

          statements = child.named_children
          next unless statements.size == 1 && statements.first.type != "var_statement"

          replacement = statements.first
          replacement.field = child.field
          statement.children[index] = replacement
          changed = true
        end
        changed
      end

      # Sorts the entries of a map literal by key, if every key is a string.
      # Returns whether the order changed.
      def self.sort_entries(map)
        entries = map.named_children
        return false unless entries.all? { |entry| entry.type == "map_entry" && entry["key"]&.type == "literal" }

        sorted = entries.sort_by.with_index { |entry, index| [entry["key"].text, index] }
        return false if sorted.map(&:object_id) == entries.map(&:object_id)

        map.children.replace(map.children.reject { |child| child.type == "map_entry" } + sorted)
        true
      end
    end
  end
end
