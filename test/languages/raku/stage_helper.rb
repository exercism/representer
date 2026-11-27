require "test_helper"

# Runs Raku's stages by hand, for the tests of each stage.
module RakuStages
  Raku = Representer::Languages::Raku

  def parse(source) = Representer::Engine::Grammar["raku"].parse(Representer::Engine.clean(source), **Raku::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Raku::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the representation's Normalise stage and the
  # engine's dropping of imports (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Raku::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
