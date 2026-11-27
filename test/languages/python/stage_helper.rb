require "test_helper"

# Runs Python's stages by hand, for the tests of each stage.
module PythonStages
  Python = Representer::Languages::Python

  def parse(source)
    Representer::Engine::Grammar["python"].parse(Representer::Engine.clean(source), **Python::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Python::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Python::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
