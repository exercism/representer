require "test_helper"

# Runs Gleam's stages by hand, for the tests of each stage.
module GleamStages
  Gleam = Rosetta::Languages::Gleam

  def parse(source)
    Rosetta::Engine::Grammar["gleam"].parse(Rosetta::Engine.clean(source), **Gleam::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Gleam::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Gleam::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The code as the body of a function.
  def wrap(body) = "pub fn f(x: Int) -> Int {\n#{body}\n}\n"
end
