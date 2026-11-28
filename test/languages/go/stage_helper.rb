require "test_helper"

# Runs Go's stages by hand, for the tests of each stage.
module GoStages
  Go = Inspector::Languages::Go

  def parse(source) = Inspector::Engine::Grammar["go"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Go::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Go::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "package p\n\nfunc F() {\n#{body}\n}\n"
end
