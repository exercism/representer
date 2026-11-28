require "test_helper"

# Runs Racket's stages by hand, for the tests of each stage.
module RacketStages
  Racket = Rosetta::Languages::Racket

  def parse(source)
    Rosetta::Engine::Grammar["racket"].parse(Rosetta::Engine.clean(source), **Racket::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Racket::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Racket::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
