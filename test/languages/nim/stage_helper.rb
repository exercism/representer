require "test_helper"

# Runs Nim's stages by hand, for the tests of each stage.
module NimStages
  Nim = Representer::Languages::Nim

  def parse(source) = Representer::Engine::Grammar["nim"].parse(Representer::Engine.clean(source), **Nim::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Nim::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Nim::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The code as the body of a proc.
  def wrap(body) = "proc f(x: int, y: int): int =\n#{body.gsub(/^/, '  ')}\n"
end
