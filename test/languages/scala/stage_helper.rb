require "test_helper"

# Runs Scala's stages by hand, for the tests of each stage.
module ScalaStages
  Scala = Representer::Languages::Scala

  def parse(source)
    Representer::Engine::Grammar["scala"].parse(Representer::Engine.clean(source), **Scala::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Scala::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Scala::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The source as the body of a method in an object.
  def in_method(body) = "object A {\n  def f(a: Int, b: Int, xs: List[Int]) = {\n#{body}\n  }\n}\n"
end
