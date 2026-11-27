require "test_helper"

# Runs F#'s stages by hand, for the tests of each stage.
module FSharpStages
  FSharp = Representer::Languages::FSharp

  def parse(source) = Representer::Engine::Grammar["fsharp"].parse(Representer::Engine.clean(source), **FSharp::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = FSharp::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(FSharp::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
