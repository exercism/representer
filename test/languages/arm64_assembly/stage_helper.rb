require "test_helper"

# Runs ARM64 assembly's stages by hand, for the tests of each stage.
module Arm64AssemblyStages
  Arm64Assembly = Rosetta::Languages::Arm64Assembly

  def parse(source)
    Rosetta::Engine::Grammar["arm64_assembly"].parse(Rosetta::Engine.clean(source),
                                                       **Arm64Assembly::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Arm64Assembly::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Arm64Assembly::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
