require "test_helper"

# Runs JavaScript's stages by hand, for the tests of each stage.
module JavascriptStages
  Javascript = Representer::Languages::Javascript

  def parse(source) = Representer::Engine::Grammar["javascript"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Javascript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Javascript::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
