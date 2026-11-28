require "test_helper"

# Runs Kotlin's stages by hand, for the tests of each stage.
module KotlinStages
  Kotlin = Rosetta::Languages::Kotlin

  def parse(source)
    Rosetta::Engine::Grammar["kotlin"].parse(Rosetta::Engine.clean(source), **Kotlin::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Kotlin::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Kotlin::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "fun f() {\n#{body}\n}\n"
end
