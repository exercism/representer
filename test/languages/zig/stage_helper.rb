require "test_helper"

# Runs Zig's stages by hand, for the tests of each stage.
module ZigStages
  Zig = Rosetta::Languages::Zig

  def parse(source) = Rosetta::Engine::Grammar["zig"].parse(Rosetta::Engine.clean(source), **Zig::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Zig::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Zig::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "pub fn f(x: u32) u32 {\n#{body}\n}\n"
end
