require "test_helper"

# Runs D's stages by hand, for the tests of each stage.
module DStages
  D = Representer::Languages::D

  def parse(source) = Representer::Engine::Grammar["d"].parse(Representer::Engine.clean(source), **D::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = D::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(D::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "void f(int a, int b, int[] xs) {\n#{body}\n}\n"
end
