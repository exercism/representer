require "test_helper"

# Runs Prolog's stages by hand, for the tests of each stage.
module PrologStages
  Prolog = Rosetta::Languages::Prolog

  def parse(source)
    Rosetta::Engine::Grammar["prolog"].parse(Rosetta::Engine.clean(source), **Prolog::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Prolog::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Prolog::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
