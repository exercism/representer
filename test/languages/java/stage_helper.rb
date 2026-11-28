require "test_helper"

# Runs Java's stages by hand, for the tests of each stage.
module JavaStages
  Java = Rosetta::Languages::Java

  def parse(source) = Rosetta::Engine::Grammar["java"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Java::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Java::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
