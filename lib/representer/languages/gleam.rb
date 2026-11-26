# What this class does to a Gleam solution's code to make its representation:
#
# - Drops comments and imports, and writes each name that an import gives
#   with `as` as the name it stands for.
# - Drops punctuation and keywords that the tree already shows.
# - Writes `f(age:)` as `f(age: age)`, and the same in patterns.
# - Writes numbers as their values (`1_000` is `1000`, `0x1F` is `31`,
#   `1.50` is `1.5`).
# - Writes a string as its value.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, the members of the exercise's stub,
#   and the language's library names.
# - Also keeps labelled arguments' labels and `main`.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # The old gleam-representer only removed blank lines and trailing
    # whitespace from the solution's files, so nothing in it is ported. This
    # class applies the same approach as the other languages.
    class Gleam < Language
      tracks "gleam"
      version 6
      grammar "gleam"
      extensions ".gleam"

      # The path in `import gleam/list` is one node with only the slashes as
      # children, so it is kept as a leaf with its whole text.
      text_nodes :module

      # The grammar has one `identifier` type for every name. The rewrites
      # below move a name that the student defines for a variable to the
      # `variable` type, so that the rename rules can tell it from other names.
      names :identifier, :variable, :constructor_name, :type_identifier, :label

      ### Drop ###

      drop "[(comment) (statement_comment) (module_comment)]"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "{", "}", "[", "]", ",", "fn", "let", "type", "const", "case", "assert"

      ### Rewrite ###

      # `f(age:)` is `f(age: age)`, and `Circle(radius:)` in a pattern is
      # `Circle(radius: radius)`.
      rewrite "(argument label: (label) @label) @argument",
        where: ->(match) { match.node.children.none? { |child| child.field == "value" } } do |match|
        match.node.children << leaf(:identifier, match[:label].text).tap { |value| value.field = "value" }
        match.node
      end
      rewrite "(record_pattern_argument label: (label) @label) @argument",
        where: ->(match) { match.node.children.none? { |child| child.field == "pattern" } } do |match|
        match.node.children << leaf(:identifier, match[:label].text).tap { |value| value.field = "pattern" }
        match.node
      end

      # Numbers are their values: `1_000` is `1000`, `0x1F` is `31`, and
      # `1.50` is `1.5`.
      numbers(:integer) { |text| Engine::Numbers.integer(text)&.to_s }
      numbers :float do |text|
        value = Engine::Numbers.decimal(text)
        value && Engine::Numbers.write_decimal(value)
      end

      # Imports only make names available, so they go. A name that an import
      # gives with `as` becomes the name it stands for: after
      # `import gleam/list as l`, `l.length` is `list.length`.
      rewrite("(source_file) @file") { |match| Gleam.drop_imports(match.node) ? match.node : nil }

      # A string is its value.
      rewrite '(string "\"") @string' do |match|
        parts = match.node.children.select(&:named?)
        next nil unless parts.all? { |part| %w[quoted_content escape_sequence].include?(part.type) }

        literal(parts.map { |part| part.type == "escape_sequence" ? Gleam.decode(part.text) : part.text }.join)
      end

      # Variables: a name that a pattern defines.
      rewrite "(let pattern: (_) @pattern)" do |match|
        Gleam.mark_variables(match[:pattern]) ? match.node : nil
      end
      rewrite "(let_assert pattern: (_) @pattern)" do |match|
        Gleam.mark_variables(match[:pattern]) ? match.node : nil
      end
      rewrite "(case_clause_patterns) @patterns" do |match|
        Gleam.mark_variables(match.node) ? match.node : nil
      end
      rewrite "(use_assignments) @assignments" do |match|
        Gleam.mark_variables(match.node) ? match.node : nil
      end

      ### Rename and keep ###

      rename "(variable) @name"
      rename "(function_parameter name: (identifier) @name)"
      rename "[(function name: (identifier) @name) (constant name: (identifier) @name)]"
      rename "[(type_name name: (type_identifier) @name) (data_constructor name: (constructor_name) @name)]"

      # A record's fields are reached through `record.field` and constructor
      # arguments, so they are renamed there too.
      rename_member "(data_constructor_argument label: (label) @name)"
      member "[(field_access field: (label) @name) (argument label: (label) @name)]"
      member "[(record_pattern_argument label: (label) @name) (record_update_argument label: (label) @name)]"

      # Callers pass a function's labelled arguments by label.
      keep "(function_parameter label: (label) @name)"

      keep "main"

      ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "f" => "\f", "\\" => "\\", "\"" => "\"" }.freeze

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au\{([0-9a-fA-F]{1,6})\}\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        else ESCAPES.fetch(code, escape)
        end
      end

      # Removes the imports, and writes each alias as the name it stands
      # for. Returns whether anything changed.
      def self.drop_imports(file)
        imports = file.children.select { |child| child.type == "import" }
        return false if imports.empty?

        aliases = {}
        imports.each do |import|
          aliases[import["alias"].text] = import["module"]&.text.to_s.split("/").last if import["alias"]
          import.each_descendant do |node|
            aliases[node["alias"].text] = node["name"].text if node.type == "unqualified_import" && node["alias"] && node["name"]
          end
        end
        file.children.reject! { |child| imports.include?(child) }
        file.each_descendant do |node|
          node.children.map! do |child|
            name = aliases[child.text] if %w[identifier type_identifier].include?(child.type) && child.leaf?
            name ? leaf(child.type, name).tap { |expanded| expanded.field = child.field } : child
          end
        end
        true
      end

      # Gives the names in a pattern the `variable` type. Returns whether
      # anything changed.
      def self.mark_variables(node)
        changed = false
        node.each_descendant do |descendant|
          next unless descendant.type == "identifier" && descendant.leaf?

          descendant.type = "variable"
          changed = true
        end
        changed
      end
    end
  end
end
