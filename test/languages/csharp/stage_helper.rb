require "test_helper"

# Runs C#'s stages by hand, for the tests of each stage.
module CSharpStages
  CSharp = Inspector::Languages::CSharp

  def parse(source) = Inspector::Engine::Grammar["c_sharp"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = CSharp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(CSharp::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
