module Representer
  module Languages
    # Red has no old representer, so there are no upstream tests to port.
    # The grammar is red/tree-sitter-red (Apache-2.0).
    #
    # Red code is a tree of blocks of words. This class removes comments,
    # keeps the brackets (a block's brackets are the only structure it has),
    # and renames the words that the solution defines: the name before a
    # colon (`total: 0`, `f: function [...]`), the parameters in a
    # function's spec, and the word that `foreach` and `repeat` give to each
    # item.
    class Red < Language
      tracks "red"
      version 2
      grammar "red"
      extensions ".red"

      # The grammar hides the words in a set word (`total:`), the start of a
      # path (`obj/`), a refinement (`/local`) and a multiline string, so
      # each is kept as a leaf with its whole text.
      text_nodes :set_word, :path_start, :refinement, :multiline_string, :raw_string

      names :word, :definition

      ### Drop ###

      drop "(comment)"

      ### Rewrite ###

      # `total:` is the word `total` in a set word.
      rewrite "(set_word) @set_word", where: ->(match) { match.node.leaf? } do |match|
        text = match.node.text
        text.end_with?(":") && text.length > 1 ? build(:set_word, leaf(:definition, text.chomp(":"))) : nil
      end

      # `obj/` is the word `obj` at the start of a path.
      rewrite "(path_start) @start", where: ->(match) { match.node.leaf? } do |match|
        text = match.node.text
        text.end_with?("/") && text.length > 1 ? build(:path_start, leaf(:word, text.chomp("/"))) : nil
      end

      ### Rename and keep ###

      rename "(function spec: (block (word)* @name))"
      rename "[(block (word \"foreach\") (word) @name) (source_file (word \"foreach\") (word) @name)]"
      rename "[(block (word \"repeat\") (word) @name) (source_file (word \"repeat\") (word) @name)]"
      rename_member "(set_word (definition) @name)"

      keep "return", "self", "system", "none", "main"
    end
  end
end
