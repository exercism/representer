require "test_helper"

# Runs GDScript's stages by hand, for the tests of each stage.
module GDScriptStages
  GDScript = Representer::Languages::GDScript

  def parse(source)
    Representer::Engine::Grammar["gdscript"].parse(Representer::Engine.clean(source), **GDScript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = GDScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(GDScript::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
