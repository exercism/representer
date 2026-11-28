require "test_helper"

# Runs Python's stages by hand, for the tests of each stage.
module PythonStages
  Python = Rosetta::Languages::Python

  def parse(source)
    Rosetta::Engine::Grammar["python"].parse(Rosetta::Engine.clean(source), **Python::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Python::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Python::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
