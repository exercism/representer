require "test_helper"

# Runs ABAP's stages by hand, for the tests of each stage.
module AbapStages
  Abap = Rosetta::Languages::Abap

  def parse(source)
    Rosetta::Engine::Grammar["abap"].parse(Rosetta::Engine.clean(source), **Abap::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Abap::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Abap::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
