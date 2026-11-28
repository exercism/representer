require "test_helper"

# Runs GDScript's stages by hand, for the tests of each stage.
module GDScriptStages
  GDScript = Inspector::Languages::GDScript

  def parse(source)
    Inspector::Engine::Grammar["gdscript"].parse(Inspector::Engine.clean(source), **GDScript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = GDScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(GDScript::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
