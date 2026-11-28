require "test_helper"

# Runs Cairo's stages by hand, for the tests of each stage.
module CairoStages
  Cairo = Inspector::Languages::Cairo

  def parse(source)
    Inspector::Engine::Grammar["cairo"].parse(Inspector::Engine.clean(source), **Cairo::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cairo::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Cairo::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  def wrap(body) = "fn f(a: u32, b: u32) -> u32 {\n#{body}\n}\n"
end
