require "test_helper"

# Runs Cairo's stages by hand, for the tests of each stage.
module CairoStages
  Cairo = Representer::Languages::Cairo

  def parse(source) = Representer::Engine::Grammar["cairo"].parse(Representer::Engine.clean(source), **Cairo::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cairo::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Cairo::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)

  def wrap(body) = "fn f(a: u32, b: u32) -> u32 {\n#{body}\n}\n"
end
