require "test_helper"

# Runs Ruby's stages by hand, for the tests of each stage.
module RubyStages
  Ruby = Representer::Languages::Ruby

  # GenerateAST's tree for the source.
  def generate_ast(source) = Ruby::GenerateAST.(Representer::Engine::Grammar["ruby"].parse(Representer::Engine.clean(source)))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Ruby::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
