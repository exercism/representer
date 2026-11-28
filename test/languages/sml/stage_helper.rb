require "test_helper"

# Runs Standard ML's stages by hand, for the tests of each stage.
module SmlStages
  Sml = Inspector::Languages::Sml

  def parse(source)
    Inspector::Engine::Grammar["sml"].parse(Inspector::Engine.clean(source), **Sml::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Sml::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Sml::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
