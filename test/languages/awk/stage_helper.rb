require "test_helper"

# Runs AWK's stages by hand, for the tests of each stage.
module AwkStages
  Awk = Rosetta::Languages::Awk

  def parse(source)
    Rosetta::Engine::Grammar["awk"].parse(Rosetta::Engine.clean(source), **Awk::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Awk::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Awk::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
