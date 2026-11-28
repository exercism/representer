require "test_helper"

# Runs Swift's stages by hand, for the tests of each stage.
module SwiftStages
  Swift = Rosetta::Languages::Swift

  def parse(source)
    Rosetta::Engine::Grammar["swift"].parse(Rosetta::Engine.clean(source), **Swift::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Swift::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Swift::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "func f(x: Int) -> Int {\n#{body}\n}\n"
end
