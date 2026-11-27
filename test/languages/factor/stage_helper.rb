require "test_helper"

# Runs Factor's stages by hand, for the tests of each stage.
module FactorStages
  Factor = Representer::Languages::Factor

  def parse(source)
    Representer::Engine::Grammar["factor"].parse(Representer::Engine.clean(source), **Factor::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Factor::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Factor::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
