module Representer::Engine
  # Turns one file of a solution into the tree seen by
  # RenameUserDefinedNodes. It parses the source (unless it is given the
  # tree already made from it by the grammar), and runs the language's
  # common GenerateAST and Normalise stages on it. Then it drops the
  # imports and runs the representation's own Normalise stage. A language
  # that doesn't define a stage skips it.
  #
  # Raises CannotRepresent if the source doesn't parse.
  class PrepareFile
    include Mandate

    initialize_with :language, :source, tree: nil

    def call
      tree = self.tree || Grammar[language.grammar].parse(Representer::Engine.clean(source), **language.parse_options)
      tree = language.run_stage(:GenerateAST, tree)
      tree = language.run_stage(:Normalise, tree)
      tree = DropImports.(tree, language.representation)
      language.representation.run_stage(:Normalise, tree)
    end
  end
end
