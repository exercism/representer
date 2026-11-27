require "test_helper"

# Runs Go's stages by hand, for the tests of each stage.
module GoStages
  Go = Representer::Languages::Go

  def parse(source) = Representer::Engine::Grammar["go"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Go::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Go::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The source as the body of a function.
  def in_function(body) = "package p\n\nfunc F() {\n#{body}\n}\n"
end
