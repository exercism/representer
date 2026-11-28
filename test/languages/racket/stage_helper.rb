require "test_helper"

# Runs Racket's stages by hand, for the tests of each stage.
module RacketStages
  Racket = Inspector::Languages::Racket

  def parse(source)
    Inspector::Engine::Grammar["racket"].parse(Inspector::Engine.clean(source), **Racket::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Racket::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Racket::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
