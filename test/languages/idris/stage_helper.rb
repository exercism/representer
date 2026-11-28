require "test_helper"

# Runs Idris's stages by hand, for the tests of each stage.
module IdrisStages
  Idris = Rosetta::Languages::Idris

  def parse(source)
    Rosetta::Engine::Grammar["idris"].parse(Rosetta::Engine.clean(source), **Idris::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Idris::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Idris::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
