require "test_helper"

# Runs WebAssembly's stages by hand, for the tests of each stage.
module WasmStages
  Wasm = Inspector::Languages::Wasm

  def parse(source) = Inspector::Engine::Grammar["wat"].parse(Inspector::Engine.clean(source), **Wasm::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Wasm::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Wasm::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
