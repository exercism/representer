require "test_helper"

# Runs Zig's stages by hand, for the tests of each stage.
module ZigStages
  Zig = Representer::Languages::Zig

  def parse(source) = Representer::Engine::Grammar["zig"].parse(Representer::Engine.clean(source), **Zig::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Zig::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Zig::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "pub fn f(x: u32) u32 {\n#{body}\n}\n"
end
