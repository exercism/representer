require "test_helper"

# Runs ABAP's stages by hand, for the tests of each stage.
module AbapStages
  Abap = Representer::Languages::Abap

  def parse(source)
    Representer::Engine::Grammar["abap"].parse(Representer::Engine.clean(source), **Abap::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Abap::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Abap::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
