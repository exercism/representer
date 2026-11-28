require "test_helper"

# Runs LFE's stages by hand, for the tests of each stage.
module LfeStages
  Lfe = Inspector::Languages::Lfe

  def parse(source)
    Inspector::Engine::Grammar["lfe"].parse(Inspector::Engine.clean(source), **Lfe::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Lfe::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Lfe::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
