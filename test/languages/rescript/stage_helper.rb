require "test_helper"

# Runs ReScript's stages by hand, for the tests of each stage.
module RescriptStages
  Rescript = Representer::Languages::Rescript

  def parse(source)
    Representer::Engine::Grammar["rescript"].parse(Representer::Engine.clean(source), **Rescript::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Rescript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Rescript::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
