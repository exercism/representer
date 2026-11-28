require "test_helper"

# Runs Wren's stages by hand, for the tests of each stage.
module WrenStages
  Wren = Inspector::Languages::Wren

  def parse(source) = Inspector::Engine::Grammar["wren"].parse(Inspector::Engine.clean(source), **Wren::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Wren::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Wren::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # The source as the body of a class.
  def in_class(body) = "class C {\n#{body}\n}\n"
end
