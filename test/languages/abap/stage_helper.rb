require "test_helper"

# Runs ABAP's stages by hand, for the tests of each stage.
module AbapStages
  Abap = Inspector::Languages::Abap

  def parse(source)
    Inspector::Engine::Grammar["abap"].parse(Inspector::Engine.clean(source), **Abap::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Abap::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Abap::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
