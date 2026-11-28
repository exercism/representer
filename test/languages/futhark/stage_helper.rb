require "test_helper"

# Runs Futhark's stages by hand, for the tests of each stage.
module FutharkStages
  Futhark = Rosetta::Languages::Futhark

  def parse(source)
    Rosetta::Engine::Grammar["futhark"].parse(Rosetta::Engine.clean(source), **Futhark::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Futhark::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Futhark::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
