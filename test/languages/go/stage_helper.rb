require "test_helper"

# Runs Go's stages by hand, for the tests of each stage.
module GoStages
  Go = Rosetta::Languages::Go

  def parse(source) = Rosetta::Engine::Grammar["go"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Go::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Go::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "package p\n\nfunc F() {\n#{body}\n}\n"
end
