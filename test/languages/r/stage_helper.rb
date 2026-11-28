require "test_helper"

# Runs R's stages by hand, for the tests of each stage.
module RStages
  R = Inspector::Languages::R

  def parse(source) = Inspector::Engine::Grammar["r"].parse(Inspector::Engine.clean(source), **R::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = R::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(R::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  def wrap(body) = "f <- function(a, b) {\n#{body}\n}\n"
end
