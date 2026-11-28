require "test_helper"

# Runs Roc's stages by hand, for the tests of each stage.
module RocStages
  Roc = Representer::Languages::Roc

  def parse(source)
    Representer::Engine::Grammar["roc"].parse(Representer::Engine.clean(source), **Roc::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Roc::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Roc::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
