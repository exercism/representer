require "test_helper"

# Runs Unison's stages by hand, for the tests of each stage.
module UnisonStages
  Unison = Rosetta::Languages::Unison

  def parse(source)
    Rosetta::Engine::Grammar["unison"].parse(Rosetta::Engine.clean(source), **Unison::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Unison::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Unison::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
