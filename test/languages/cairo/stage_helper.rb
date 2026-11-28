require "test_helper"

# Runs Cairo's stages by hand, for the tests of each stage.
module CairoStages
  Cairo = Rosetta::Languages::Cairo

  def parse(source)
    Rosetta::Engine::Grammar["cairo"].parse(Rosetta::Engine.clean(source), **Cairo::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cairo::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Cairo::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  def wrap(body) = "fn f(a: u32, b: u32) -> u32 {\n#{body}\n}\n"
end
