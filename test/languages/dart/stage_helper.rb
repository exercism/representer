require "test_helper"

# Runs Dart's stages by hand, for the tests of each stage.
module DartStages
  Dart = Inspector::Languages::Dart

  def parse(source) = Inspector::Engine::Grammar["dart"].parse(Inspector::Engine.clean(source), **Dart::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Dart::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Dart::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  def wrap(body) = "int f(int a, int b) {\n#{body}\n}\n"
end
