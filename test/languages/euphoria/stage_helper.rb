require "test_helper"

# Runs Euphoria's stages by hand, for the tests of each stage.
module EuphoriaStages
  Euphoria = Inspector::Languages::Euphoria

  def parse(source)
    Inspector::Engine::Grammar["euphoria"].parse(Inspector::Engine.clean(source), **Euphoria::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Euphoria::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Euphoria::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
