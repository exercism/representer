require "test_helper"

# Runs Red's stages by hand, for the tests of each stage.
module RedStages
  Red = Rosetta::Languages::Red

  def parse(source) = Rosetta::Engine::Grammar["red"].parse(Rosetta::Engine.clean(source), **Red::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Red::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Red::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
