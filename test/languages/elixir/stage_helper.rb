require "test_helper"

# Runs Elixir's stages by hand, for the tests of each stage.
module ElixirStages
  Elixir = Rosetta::Languages::Elixir

  def parse(source) = Rosetta::Engine::Grammar["elixir"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Elixir::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Elixir::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
