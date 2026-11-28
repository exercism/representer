require "test_helper"

# Runs C's stages by hand, for the tests of each stage.
module CStages
  C = Rosetta::Languages::C

  def parse(source) = Rosetta::Engine::Grammar["c"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = C::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(C::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
