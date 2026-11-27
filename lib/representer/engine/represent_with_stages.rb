module Representer::Engine
  # Represents the source files of a solution in a staged language (see
  # Engine::Language):
  #
  # 1. PrepareFile parses each file (unless parsed already holds its tree)
  #    and runs the language's GenerateAST and Normalise stages on it.
  # 2. RenameUserDefinedNodes marks every name the solution defines, in
  #    all the files together.
  # 3. JoinFiles joins the files into one tree.
  # 4. The language's Reorder stage runs on the joined tree, if the
  #    language defines one.
  # 5. NumberPlaceholders numbers the marked names, and Serialize writes
  #    the tree out.
  class RepresentWithStages
    include Mandate

    # parsed holds the tree of each source already parsed by the grammar, in
    # the same order as the sources, and nil for the others.
    initialize_with :language, :sources, parsed: []

    def call
      trees = sources.each_with_index.map { |source, index| PrepareFile.(language, source, tree: parsed[index]) }
      RenameUserDefinedNodes.(trees, language)
      tree = JoinFiles.(trees, trees.first.type, nil)
      tree = language.run_stage(:Reorder, tree)
      mapping = NumberPlaceholders.(tree, language)
      Result.new(representation: Serialize.(tree, nil), mapping:, version: language.version, representer: language)
    end
  end
end
