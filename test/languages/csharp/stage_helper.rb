require "test_helper"

# Runs C#'s stages by hand, for the tests of each stage.
module CSharpStages
  CSharp = Representer::Languages::CSharp

  def parse(source) = Representer::Engine::Grammar["c_sharp"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = CSharp::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(CSharp::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
