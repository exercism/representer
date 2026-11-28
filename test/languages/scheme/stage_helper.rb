require "test_helper"

# Runs Scheme's stages by hand, for the tests of each stage.
module SchemeStages
  Scheme = Rosetta::Languages::Scheme

  def parse(source)
    Rosetta::Engine::Grammar["scheme"].parse(Rosetta::Engine.clean(source), **Scheme::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Scheme::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Scheme::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
