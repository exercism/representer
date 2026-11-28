require "test_helper"

# Runs Fortran's stages by hand, for the tests of each stage.
module FortranStages
  Fortran = Rosetta::Languages::Fortran

  def parse(source)
    Rosetta::Engine::Grammar["fortran"].parse(Rosetta::Engine.clean(source), **Fortran::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Fortran::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Fortran::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
