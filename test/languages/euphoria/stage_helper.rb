require "test_helper"

# Runs Euphoria's stages by hand, for the tests of each stage.
module EuphoriaStages
  Euphoria = Rosetta::Languages::Euphoria

  def parse(source)
    Rosetta::Engine::Grammar["euphoria"].parse(Rosetta::Engine.clean(source), **Euphoria::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Euphoria::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Euphoria::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
