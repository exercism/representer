require "test_helper"

# Runs jq's stages by hand, for the tests of each stage.
module JqStages
  Jq = Representer::Languages::Jq

  def parse(source)
    Representer::Engine::Grammar["jq"].parse(Representer::Engine.clean(source), **Jq::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Jq::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Jq::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
