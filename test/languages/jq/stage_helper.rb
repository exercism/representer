require "test_helper"

# Runs jq's stages by hand, for the tests of each stage.
module JqStages
  Jq = Inspector::Languages::Jq

  def parse(source)
    Inspector::Engine::Grammar["jq"].parse(Inspector::Engine.clean(source), **Jq::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Jq::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Jq::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
