require "test_helper"

# Runs Java's stages by hand, for the tests of each stage.
module JavaStages
  Java = Inspector::Languages::Java

  def parse(source) = Inspector::Engine::Grammar["java"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Java::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Java::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
