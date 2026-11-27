require "test_helper"

# Runs Crystal's stages by hand, for the tests of each stage.
module CrystalStages
  Crystal = Representer::Languages::Crystal

  def parse(source) = Representer::Engine::Grammar["crystal"].parse(Representer::Engine.clean(source), **Crystal::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Crystal::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Crystal::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)

  # The source as the body of a class.
  def in_class(body) = "class C\n#{body}\nend\n"
end
