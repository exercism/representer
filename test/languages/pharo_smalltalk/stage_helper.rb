require "test_helper"

# Runs Pharo Smalltalk's stages by hand, for the tests of each stage.
module PharoSmalltalkStages
  PharoSmalltalk = Inspector::Languages::PharoSmalltalk

  def parse(source)
    Inspector::Engine::Grammar["pharo_smalltalk"].parse(Inspector::Engine.clean(source),
                                                        **PharoSmalltalk::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = PharoSmalltalk::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(PharoSmalltalk::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
