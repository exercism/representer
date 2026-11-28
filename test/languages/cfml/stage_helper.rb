require "test_helper"

# Runs CFML's stages by hand, for the tests of each stage.
module CFMLStages
  CFML = Inspector::Languages::CFML

  def parse(source)
    Inspector::Engine::Grammar["cfscript"].parse(Inspector::Engine.clean(source), **CFML::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = CFML::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(CFML::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
