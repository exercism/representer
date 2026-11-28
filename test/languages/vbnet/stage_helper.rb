require "test_helper"

# Runs VB.NET's stages by hand, for the tests of each stage.
module VBNetStages
  VBNet = Rosetta::Languages::VBNet

  def parse(source)
    Rosetta::Engine::Grammar["vbnet"].parse(Rosetta::Engine.clean(source), **VBNet::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = VBNet::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(VBNet::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
