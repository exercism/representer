require "test_helper"

# Runs Rust's stages by hand, for the tests of each stage.
module RustStages
  Rust = Rosetta::Languages::Rust

  def parse(source) = Rosetta::Engine::Grammar["rust"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Rust::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Rust::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  def wrap(body) = "fn f() {\n#{body}\n}\n"
end
