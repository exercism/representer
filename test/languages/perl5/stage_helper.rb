require "test_helper"

# Runs Perl's stages by hand, for the tests of each stage.
module Perl5Stages
  Perl5 = Rosetta::Languages::Perl5

  def parse(source)
    Rosetta::Engine::Grammar["perl"].parse(Rosetta::Engine.clean(source), **Perl5::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Perl5::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Perl5::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
