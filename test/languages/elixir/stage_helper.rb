require "test_helper"

# Runs Elixir's stages by hand, for the tests of each stage.
module ElixirStages
  Elixir = Inspector::Languages::Elixir

  def parse(source) = Inspector::Engine::Grammar["elixir"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Elixir::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Elixir::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
