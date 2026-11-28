require "test_helper"

# Runs CFML's stages by hand, for the tests of each stage.
module CFMLStages
  CFML = Rosetta::Languages::CFML

  def parse(source)
    Rosetta::Engine::Grammar["cfscript"].parse(Rosetta::Engine.clean(source), **CFML::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = CFML::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(CFML::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
