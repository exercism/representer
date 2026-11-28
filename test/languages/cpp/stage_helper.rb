require "test_helper"

# Runs C++'s stages by hand, for the tests of each stage.
module CppStages
  Cpp = Inspector::Languages::Cpp

  def parse(source) = Inspector::Engine::Grammar["cpp"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cpp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Cpp::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
