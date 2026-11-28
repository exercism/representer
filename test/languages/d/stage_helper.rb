require "test_helper"

# Runs D's stages by hand, for the tests of each stage.
module DStages
  D = Rosetta::Languages::D

  def parse(source) = Rosetta::Engine::Grammar["d"].parse(Rosetta::Engine.clean(source), **D::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = D::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(D::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "void f(int a, int b, int[] xs) {\n#{body}\n}\n"
end
