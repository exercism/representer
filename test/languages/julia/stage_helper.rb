require "test_helper"

# Runs Julia's stages by hand, for the tests of each stage.
module JuliaStages
  Julia = Rosetta::Languages::Julia

  def parse(source)
    Rosetta::Engine::Grammar["julia"].parse(Rosetta::Engine.clean(source), **Julia::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Julia::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Julia::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
