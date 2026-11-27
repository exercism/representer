require "test_helper"

# Runs TypeScript's stages by hand, for the tests of each stage.
module TypescriptStages
  Typescript = Representer::Languages::Typescript

  def parse(source) = Representer::Engine::Grammar["typescript"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Typescript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Typescript::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
