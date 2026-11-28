require "test_helper"

# Runs Scala's stages by hand, for the tests of each stage.
module ScalaStages
  Scala = Inspector::Languages::Scala

  def parse(source)
    Inspector::Engine::Grammar["scala"].parse(Inspector::Engine.clean(source), **Scala::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Scala::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Scala::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # The source as the body of a method in an object.
  def in_method(body) = "object A {\n  def f(a: Int, b: Int, xs: List[Int]) = {\n#{body}\n  }\n}\n"
end
