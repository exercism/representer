require "test_helper"

# Runs VB.NET's stages by hand, for the tests of each stage.
module VBNetStages
  VBNet = Inspector::Languages::VBNet

  def parse(source)
    Inspector::Engine::Grammar["vbnet"].parse(Inspector::Engine.clean(source), **VBNet::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = VBNet::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(VBNet::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
