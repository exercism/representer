require "test_helper"

# Runs Factor's stages by hand, for the tests of each stage.
module FactorStages
  Factor = Rosetta::Languages::Factor

  def parse(source)
    Rosetta::Engine::Grammar["factor"].parse(Rosetta::Engine.clean(source), **Factor::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Factor::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Factor::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
