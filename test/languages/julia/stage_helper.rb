require "test_helper"

# Runs Julia's stages by hand, for the tests of each stage.
module JuliaStages
  Julia = Inspector::Languages::Julia

  def parse(source)
    Inspector::Engine::Grammar["julia"].parse(Inspector::Engine.clean(source), **Julia::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Julia::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Julia::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
