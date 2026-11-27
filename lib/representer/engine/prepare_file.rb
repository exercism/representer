module Representer::Engine
  # Turns one file of a staged language into the tree seen by
  # RenameUserDefinedNodes. It parses the source, runs the language's
  # GenerateAST stage, drops the imports, and runs the language's
  # Normalise stage. A language that doesn't define a stage skips it.
  #
  # Raises CannotRepresent if the source doesn't parse.
  class PrepareFile
    include Mandate

    initialize_with :language, :source

    def call
      tree = Grammar[language.grammar].parse(Representer::Engine.clean(source))
      tree = language.run_stage(:GenerateAST, tree)
      tree = DropImports.(tree, language)
      language.run_stage(:Normalise, tree)
    end
  end
end
