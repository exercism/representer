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
      version 2
      grammar "factor"
      extensions ".factor"

      # A comment starts at a `!` or `#!` word, and runs to the end of the
      # line. A string is matched first, so a `!` inside one stays.
      COMMENTS = /"(?:\\.|[^"\\])*"|(?<!\S)#?!(?=\s|\z)[^\n]*/m

      def self.call(solution_files, exercise_files)
        stripped = solution_files.transform_values do |source|
          source.gsub(COMMENTS) { |match| match.start_with?('"') ? match : "" }
        end
        super(stripped, exercise_files)
      end

      names :symbol

      ### Drop ###

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "--", "[", "]", "{", "}", ";"

      ### Rewrite ###

      # 1,000 and 1_000 are 1000.
      rewrite "(base10 /[,_]/) @number" do |match|
        leaf(:base10, match[:number].text.delete(",_"))
      end

      ### Rename and keep ###

      # The name of a word defined with `:` or `::`, the names in its stack
      # effect (the parameters of a `::` word), and the names bound by `:>`.
      rename "(definition (_) (symbol) @name)"
      rename "(effect (inputs (symbol)* @name))"
      rename "(effect (outputs (symbol)* @name))"
      rename "(var_binding (symbol)* @name)"

      keep "main", "?"
    end
  end
end
