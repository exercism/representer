require "test_helper"

# Runs Ballerina's stages by hand, for the tests of each stage.
module BallerinaStages
  Ballerina = Representer::Languages::Ballerina

  def parse(source) = Representer::Engine::Grammar["ballerina"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Ballerina::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Ballerina::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
