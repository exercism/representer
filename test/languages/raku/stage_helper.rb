require "test_helper"

# Runs Raku's stages by hand, for the tests of each stage.
module RakuStages
  Raku = Inspector::Languages::Raku

  def parse(source) = Inspector::Engine::Grammar["raku"].parse(Inspector::Engine.clean(source), **Raku::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Raku::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the representation's Normalise stage and the
  # engine's dropping of imports (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Raku::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
