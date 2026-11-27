require "test_helper"

# Runs Scheme's stages by hand, for the tests of each stage.
module SchemeStages
  Scheme = Representer::Languages::Scheme

  def parse(source) = Representer::Engine::Grammar["scheme"].parse(Representer::Engine.clean(source), **Scheme::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Scheme::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Scheme::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
