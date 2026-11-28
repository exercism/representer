require "test_helper"

# Runs Scheme's stages by hand, for the tests of each stage.
module SchemeStages
  Scheme = Inspector::Languages::Scheme

  def parse(source)
    Inspector::Engine::Grammar["scheme"].parse(Inspector::Engine.clean(source), **Scheme::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Scheme::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Scheme::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
