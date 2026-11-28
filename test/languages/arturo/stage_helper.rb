require "test_helper"

# Runs Arturo's stages by hand, for the tests of each stage.
module ArturoStages
  Arturo = Inspector::Languages::Arturo

  def parse(source)
    Inspector::Engine::Grammar["arturo"].parse(Inspector::Engine.clean(source), **Arturo::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Arturo::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Arturo::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
