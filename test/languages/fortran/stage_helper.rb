require "test_helper"

# Runs Fortran's stages by hand, for the tests of each stage.
module FortranStages
  Fortran = Representer::Languages::Fortran

  def parse(source)
    Representer::Engine::Grammar["fortran"].parse(Representer::Engine.clean(source), **Fortran::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Fortran::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Fortran::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
