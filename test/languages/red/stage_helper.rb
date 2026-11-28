require "test_helper"

# Runs Red's stages by hand, for the tests of each stage.
module RedStages
  Red = Inspector::Languages::Red

  def parse(source) = Inspector::Engine::Grammar["red"].parse(Inspector::Engine.clean(source), **Red::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Red::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Red::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
