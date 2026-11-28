require "test_helper"

# Runs Wren's stages by hand, for the tests of each stage.
module WrenStages
  Wren = Rosetta::Languages::Wren

  def parse(source) = Rosetta::Engine::Grammar["wren"].parse(Rosetta::Engine.clean(source), **Wren::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Wren::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Wren::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a class.
  def in_class(body) = "class C {\n#{body}\n}\n"
end
