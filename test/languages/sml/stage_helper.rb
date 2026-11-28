require "test_helper"

# Runs Standard ML's stages by hand, for the tests of each stage.
module SmlStages
  Sml = Representer::Languages::Sml

  def parse(source)
    Representer::Engine::Grammar["sml"].parse(Representer::Engine.clean(source), **Sml::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Sml::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Sml::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
