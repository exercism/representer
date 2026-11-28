require "test_helper"

# Runs C++'s stages by hand, for the tests of each stage.
module CppStages
  Cpp = Rosetta::Languages::Cpp

  def parse(source) = Rosetta::Engine::Grammar["cpp"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cpp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Cpp::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
