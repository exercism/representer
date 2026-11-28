require "test_helper"

# Runs Factor's stages by hand, for the tests of each stage.
module FactorStages
  Factor = Inspector::Languages::Factor

  def parse(source)
    Inspector::Engine::Grammar["factor"].parse(Inspector::Engine.clean(source), **Factor::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Factor::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Factor::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
