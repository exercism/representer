require "test_helper"

# Runs Odin's stages by hand, for the tests of each stage.
module OdinStages
  Odin = Representer::Languages::Odin

  def parse(source)
    Representer::Engine::Grammar["odin"].parse(Representer::Engine.clean(source), **Odin::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Odin::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Odin::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
