require "test_helper"

# Runs ReasonML's stages by hand, for the tests of each stage.
module ReasonmlStages
  Reasonml = Rosetta::Languages::Reasonml

  def parse(source)
    Rosetta::Engine::Grammar["reasonml"].parse(Rosetta::Engine.clean(source), **Reasonml::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Reasonml::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Reasonml::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
