require "test_helper"

# Runs Groovy's stages by hand, for the tests of each stage.
module GroovyStages
  Groovy = Inspector::Languages::Groovy

  def parse(source)
    Inspector::Engine::Grammar["groovy"].parse(Inspector::Engine.clean(source), **Groovy::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Groovy::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Groovy::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
