require "test_helper"

# Runs Ballerina's stages by hand, for the tests of each stage.
module BallerinaStages
  Ballerina = Inspector::Languages::Ballerina

  def parse(source) = Inspector::Engine::Grammar["ballerina"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Ballerina::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Ballerina::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
