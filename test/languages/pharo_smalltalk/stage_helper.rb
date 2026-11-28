require "test_helper"

# Runs Pharo Smalltalk's stages by hand, for the tests of each stage.
module PharoSmalltalkStages
  PharoSmalltalk = Rosetta::Languages::PharoSmalltalk

  def parse(source)
    Rosetta::Engine::Grammar["pharo_smalltalk"].parse(Rosetta::Engine.clean(source),
                                                        **PharoSmalltalk::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = PharoSmalltalk::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(PharoSmalltalk::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
