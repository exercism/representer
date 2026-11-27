require "test_helper"

# Runs Wren's stages by hand, for the tests of each stage.
module WrenStages
  Wren = Representer::Languages::Wren

  def parse(source) = Representer::Engine::Grammar["wren"].parse(Representer::Engine.clean(source), **Wren::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Wren::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Wren::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The source as the body of a class.
  def in_class(body) = "class C {\n#{body}\n}\n"
end
