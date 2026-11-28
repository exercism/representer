require "test_helper"

# Runs Unison's stages by hand, for the tests of each stage.
module UnisonStages
  Unison = Inspector::Languages::Unison

  def parse(source)
    Inspector::Engine::Grammar["unison"].parse(Inspector::Engine.clean(source), **Unison::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Unison::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Unison::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
