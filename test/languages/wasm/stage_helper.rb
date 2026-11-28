require "test_helper"

# Runs WebAssembly's stages by hand, for the tests of each stage.
module WasmStages
  Wasm = Rosetta::Languages::Wasm

  def parse(source) = Rosetta::Engine::Grammar["wat"].parse(Rosetta::Engine.clean(source), **Wasm::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Wasm::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Wasm::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
