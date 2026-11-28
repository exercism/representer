require "test_helper"

# Runs CFML's stages by hand, for the tests of each stage.
module CFMLStages
  CFML = Representer::Languages::CFML

  def parse(source)
    Representer::Engine::Grammar["cfscript"].parse(Representer::Engine.clean(source), **CFML::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = CFML::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(CFML::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
