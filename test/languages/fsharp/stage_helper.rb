require "test_helper"

# Runs F#'s stages by hand, for the tests of each stage.
module FSharpStages
  FSharp = Rosetta::Languages::FSharp

  def parse(source)
    Rosetta::Engine::Grammar["fsharp"].parse(Rosetta::Engine.clean(source), **FSharp::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = FSharp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(FSharp::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
