require "test_helper"

# Runs Ruby's stages by hand, for the tests of each stage.
module RubyStages
  Ruby = Representer::Languages::Ruby

  # GenerateAST's tree for the source.
  def generate_ast(source) = Ruby::GenerateAST.(Representer::Engine::Grammar["ruby"].parse(Representer::Engine.clean(source)))

  # The tree after GenerateAST and Normalise.
  def normalise(source) = Ruby::Normalise.(generate_ast(source))

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
