require "test_helper"

# Runs PHP's stages by hand, for the tests of each stage.
module PHPStages
  PHP = Rosetta::Languages::PHP

  def parse(source) = Rosetta::Engine::Grammar["php"].parse(Rosetta::Engine.clean(source), **PHP::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = PHP::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, both Normalise stages and the engine's
  # dropping of imports (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(PHP::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
