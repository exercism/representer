require "test_helper"

# Runs AWK's stages by hand, for the tests of each stage.
module AwkStages
  Awk = Inspector::Languages::Awk

  def parse(source)
    Inspector::Engine::Grammar["awk"].parse(Inspector::Engine.clean(source), **Awk::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Awk::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Awk::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
