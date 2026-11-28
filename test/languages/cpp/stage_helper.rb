require "test_helper"

# Runs C++'s stages by hand, for the tests of each stage.
module CppStages
  Cpp = Representer::Languages::Cpp

  def parse(source) = Representer::Engine::Grammar["cpp"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cpp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Cpp::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
