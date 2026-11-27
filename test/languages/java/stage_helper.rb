require "test_helper"

# Runs Java's stages by hand, for the tests of each stage.
module JavaStages
  Java = Representer::Languages::Java

  def parse(source) = Representer::Engine::Grammar["java"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Java::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Java::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
