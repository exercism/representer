require "test_helper"

# Runs WebAssembly's stages by hand, for the tests of each stage.
module WasmStages
  Wasm = Representer::Languages::Wasm

  def parse(source) = Representer::Engine::Grammar["wat"].parse(Representer::Engine.clean(source), **Wasm::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Wasm::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Wasm::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
