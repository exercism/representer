require "test_helper"

# Runs Ballerina's stages by hand, for the tests of each stage.
module BallerinaStages
  Ballerina = Rosetta::Languages::Ballerina

  def parse(source) = Rosetta::Engine::Grammar["ballerina"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Ballerina::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Ballerina::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
