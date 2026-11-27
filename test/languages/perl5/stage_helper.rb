require "test_helper"

# Runs Perl's stages by hand, for the tests of each stage.
module Perl5Stages
  Perl5 = Representer::Languages::Perl5

  def parse(source)
    Representer::Engine::Grammar["perl"].parse(Representer::Engine.clean(source), **Perl5::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Perl5::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Perl5::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
