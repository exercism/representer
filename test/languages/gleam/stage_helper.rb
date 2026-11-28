require "test_helper"

# Runs Gleam's stages by hand, for the tests of each stage.
module GleamStages
  Gleam = Inspector::Languages::Gleam

  def parse(source)
    Inspector::Engine::Grammar["gleam"].parse(Inspector::Engine.clean(source), **Gleam::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Gleam::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Gleam::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # The code as the body of a function.
  def wrap(body) = "pub fn f(x: Int) -> Int {\n#{body}\n}\n"
end
