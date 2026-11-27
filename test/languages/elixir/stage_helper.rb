require "test_helper"

# Runs Elixir's stages by hand, for the tests of each stage.
module ElixirStages
  Elixir = Representer::Languages::Elixir

  def parse(source) = Representer::Engine::Grammar["elixir"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Elixir::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Elixir::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
