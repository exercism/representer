require "test_helper"

# Runs C's stages by hand, for the tests of each stage.
module CStages
  C = Representer::Languages::C

  def parse(source) = Representer::Engine::Grammar["c"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = C::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(C::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
