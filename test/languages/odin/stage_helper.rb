require "test_helper"

# Runs Odin's stages by hand, for the tests of each stage.
module OdinStages
  Odin = Rosetta::Languages::Odin

  def parse(source)
    Rosetta::Engine::Grammar["odin"].parse(Rosetta::Engine.clean(source), **Odin::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Odin::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Odin::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
