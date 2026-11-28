require "test_helper"

# Runs C#'s stages by hand, for the tests of each stage.
module CSharpStages
  CSharp = Rosetta::Languages::CSharp

  def parse(source) = Rosetta::Engine::Grammar["c_sharp"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = CSharp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(CSharp::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
