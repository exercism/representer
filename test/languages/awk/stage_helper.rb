require "test_helper"

# Runs AWK's stages by hand, for the tests of each stage.
module AwkStages
  Awk = Representer::Languages::Awk

  def parse(source)
    Representer::Engine::Grammar["awk"].parse(Representer::Engine.clean(source), **Awk::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Awk::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Awk::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
