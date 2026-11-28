require "test_helper"

# Runs Dart's stages by hand, for the tests of each stage.
module DartStages
  Dart = Representer::Languages::Dart

  def parse(source) = Representer::Engine::Grammar["dart"].parse(Representer::Engine.clean(source), **Dart::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Dart::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Dart::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  def wrap(body) = "int f(int a, int b) {\n#{body}\n}\n"
end
