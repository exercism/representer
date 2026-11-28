require "test_helper"

# Runs PHP's stages by hand, for the tests of each stage.
module PHPStages
  PHP = Inspector::Languages::PHP

  def parse(source) = Inspector::Engine::Grammar["php"].parse(Inspector::Engine.clean(source), **PHP::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = PHP::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, both Normalise stages and the engine's
  # dropping of imports (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(PHP::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
