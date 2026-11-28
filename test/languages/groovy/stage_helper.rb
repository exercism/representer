require "test_helper"

# Runs Groovy's stages by hand, for the tests of each stage.
module GroovyStages
  Groovy = Rosetta::Languages::Groovy

  def parse(source)
    Rosetta::Engine::Grammar["groovy"].parse(Rosetta::Engine.clean(source), **Groovy::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Groovy::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Groovy::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
