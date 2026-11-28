require "test_helper"

# Runs Perl's stages by hand, for the tests of each stage.
module Perl5Stages
  Perl5 = Inspector::Languages::Perl5

  def parse(source)
    Inspector::Engine::Grammar["perl"].parse(Inspector::Engine.clean(source), **Perl5::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Perl5::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Perl5::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
