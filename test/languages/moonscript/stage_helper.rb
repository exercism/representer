require "test_helper"

# Runs MoonScript's stages by hand, for the tests of each stage.
module MoonscriptStages
  Moonscript = Rosetta::Languages::Moonscript

  def parse(source)
    Rosetta::Engine::Grammar["moonscript"].parse(Rosetta::Engine.clean(source),
                                                   **Moonscript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Moonscript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Moonscript::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
