require "test_helper"

# Runs Pyret's stages by hand, for the tests of each stage.
module PyretStages
  Pyret = Inspector::Languages::Pyret

  def parse(source)
    Inspector::Engine::Grammar["pyret"].parse(Inspector::Engine.clean(source), **Pyret::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Pyret::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Pyret::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
