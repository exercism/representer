require "test_helper"

# Runs Red's stages by hand, for the tests of each stage.
module RedStages
  Red = Representer::Languages::Red

  def parse(source) = Representer::Engine::Grammar["red"].parse(Representer::Engine.clean(source), **Red::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Red::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Red::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
