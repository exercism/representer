require "test_helper"

# Runs Crystal's stages by hand, for the tests of each stage.
module CrystalStages
  Crystal = Rosetta::Languages::Crystal

  def parse(source)
    Rosetta::Engine::Grammar["crystal"].parse(Rosetta::Engine.clean(source), **Crystal::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Crystal::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Crystal::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a class.
  def in_class(body) = "class C\n#{body}\nend\n"
end
