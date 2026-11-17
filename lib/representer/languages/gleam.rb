module Representer
  module Languages
    # The old gleam-representer only removed blank lines and trailing
    # whitespace from the solution's files, so nothing in it is ported. This
    # class applies the same approach as the other languages.
    class Gleam < Language
      tracks "gleam"
      version 2
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
      drop_tokens "(", ")", "{", "}", "[", "]", ",", "fn", "let", "import", "type", "const", "case", "assert"

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

      # 1_000 is 1000.
      rewrite "[(integer /_/) @number (float /_/) @number]" do |match|
        leaf(match[:number].type, match[:number].text.delete("_"))
      end

      # SortImports: the imports at the start of the file are in a fixed
      # order, and so are the names in `import m.{b, a}`.
      rewrite "(unqualified_imports) @imports" do |match|
        sorted = match.node.children.sort_by.with_index { |child, index| [Gleam.import_key(child), index] }
        next nil if sorted.map(&:inspect) == match.node.children.map(&:inspect)

        match.node.children.replace(sorted)
        match.node
      end
      rewrite "(source_file) @file" do |match|
        run = match.node.children.take_while { |child| child.type == "import" }
        sorted = run.sort_by.with_index { |child, index| [Gleam.import_key(child), index] }
        next nil if sorted.map(&:inspect) == run.map(&:inspect)

        match.node.children[0, run.size] = sorted
        match.node
      end

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
      rename "(import alias: (identifier) @name)"
      rename "(unqualified_import alias: (identifier) @name)"
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

      # The text to sort an import by: the module path, then the alias.
      def self.import_key(node)
        parts = []
        node.each_descendant { |descendant| parts << descendant.text.to_s if descendant.leaf? }
        parts.join(" ")
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
