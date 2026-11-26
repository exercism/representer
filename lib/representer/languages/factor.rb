# What this class does to a Factor solution's code to make its representation:
#
# - Drops comments (`! text` and `#! text`) before parsing.
# - Drops `USING: ... ;` and `USE: word` declarations.
# - Drops brackets and the stack effect's `--`, which the tree already
#   shows.
# - Writes numbers as their values (`1,000` is `1000`, `0x1F` is `31`,
#   `1.50` is `1.5`).
# - Renames the words defined with `:` or `::`, the names in their stack
#   effects and the names bound with `:>`.
# - Keeps the words in declarations such as `TUPLE:` and `CONSTANT:`, and
#   `main`.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # Factor has no old representer, so there are no upstream tests to port.
    # The grammar is erochest/tree-sitter-factor. Its repository has no
    # licence file, although its grammar.js, package.json and Cargo.toml
    # say MIT, so its licence is unclear.
    #
    # The grammar doesn't know Factor's comments (`! text` to the end of the
    # line, and `#! text`) and reads them as words, so this class removes
    # them from the source before parsing.
    #
    # Factor code is mostly a flat list of words, and the grammar only gives
    # structure to definitions (`: name ( effect ) ... ;`), quotations,
    # collections and `:>` bindings. This class renames the names of words
    # that a solution defines with `:` or `::`, the names in stack effects
    # and the names bound with `:>`. Words in declarations such as TUPLE:,
    # CONSTANT: and USING: have no structure in the tree, so they keep their
    # names.
    class Factor < Language
      tracks "factor"
      version 3
      grammar "factor"
      extensions ".factor"

      # A comment starts at a `!` or `#!` word, and runs to the end of the
      # line. A string is matched first, so a `!` inside one stays.
      COMMENTS = /"(?:\\.|[^"\\])*"|(?<!\S)#?!(?=\s|\z)[^\n]*/m

      def self.call(solution_files, exercise_files)
        stripped = solution_files.transform_values do |source|
          Engine.clean(source).gsub(COMMENTS) { |match| match.start_with?('"') ? match : "" }
        end
        super(stripped, exercise_files)
      end

      names :symbol

      ### Drop ###

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "--", "[", "]", "{", "}", ";"

      ### Rewrite ###

      # `USING: kernel math ;` and `USE: io` only make words available. The
      # grammar reads them as plain words, so this removes the words from
      # `USING:` to its `;`, and `USE:` with the word after it.
      rewrite("(source_file) @file") { |match| Factor.drop_imports(match.node) ? match.node : nil }

      # Numbers are their values: `1,000` and `1_000` are `1000`, `0x1F` is
      # `31`, and `1.50` is `1.5`.
      { "base10" => {}, "base16" => { "0x" => 16 }, "base8" => { "0o" => 8 }, "base2" => { "0b" => 2 } }.each do |type, prefixes|
        rewrite "(#{type}) @number", where: ->(match) { match.node.leaf? } do |match|
          value = Engine::Numbers.integer(match.node.text.delete(","), prefixes:)
          value && (type != "base10" || value.to_s != match.node.text) ? leaf("base10", value.to_s) : nil
        end
      end
      numbers :float do |text|
        value = Engine::Numbers.decimal(text.delete(","))
        value && Engine::Numbers.write_decimal(value)
      end

      ### Rename and keep ###

      # The name of a word defined with `:` or `::`, the names in its stack
      # effect (the parameters of a `::` word), and the names bound by `:>`.
      rename "(definition (_) (symbol) @name)"
      rename "(effect (inputs (symbol)* @name))"
      rename "(effect (outputs (symbol)* @name))"
      rename "(var_binding (symbol)* @name)"

      keep "main", "?"

      # Removes the `USING: ... ;` and `USE: word` declarations from a file.
      # Returns whether anything changed.
      def self.drop_imports(file)
        children = file.children
        kept = []
        index = 0
        while index < children.size
          child = children[index]
          if child.type == "symbol" && child.text == "USING:"
            index += 1 until index >= children.size || (children[index].type == "symbol" && children[index].text == ";")
            index += 1
          elsif child.type == "symbol" && child.text == "USE:"
            index += 2
          else
            kept << child
            index += 1
          end
        end
        return false if kept.size == children.size

        file.children = kept
        true
      end
    end
  end
end
