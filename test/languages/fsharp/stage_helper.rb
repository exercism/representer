require "test_helper"

# Runs F#'s stages by hand, for the tests of each stage.
module FSharpStages
  FSharp = Inspector::Languages::FSharp

  def parse(source)
    Inspector::Engine::Grammar["fsharp"].parse(Inspector::Engine.clean(source), **FSharp::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = FSharp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(FSharp::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
