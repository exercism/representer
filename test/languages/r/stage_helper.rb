require "test_helper"

# Runs R's stages by hand, for the tests of each stage.
module RStages
  R = Rosetta::Languages::R

  def parse(source) = Rosetta::Engine::Grammar["r"].parse(Rosetta::Engine.clean(source), **R::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = R::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(R::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  def wrap(body) = "f <- function(a, b) {\n#{body}\n}\n"
end
