require "test_helper"

# Runs Roc's stages by hand, for the tests of each stage.
module RocStages
  Roc = Inspector::Languages::Roc

  def parse(source)
    Inspector::Engine::Grammar["roc"].parse(Inspector::Engine.clean(source), **Roc::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Roc::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Roc::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
