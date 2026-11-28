require "test_helper"

# Runs TypeScript's stages by hand, for the tests of each stage.
module TypeScriptStages
  TypeScript = Inspector::Languages::TypeScript

  def parse(source) = Inspector::Engine::Grammar["typescript"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = TypeScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(TypeScript::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
