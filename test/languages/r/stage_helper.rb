require "test_helper"

# Runs R's stages by hand, for the tests of each stage.
module RStages
  R = Representer::Languages::R

  def parse(source) = Representer::Engine::Grammar["r"].parse(Representer::Engine.clean(source), **R::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = R::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(R::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  def wrap(body) = "f <- function(a, b) {\n#{body}\n}\n"
end
