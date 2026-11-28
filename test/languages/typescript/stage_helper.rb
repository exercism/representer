require "test_helper"

# Runs TypeScript's stages by hand, for the tests of each stage.
module TypeScriptStages
  TypeScript = Representer::Languages::TypeScript

  def parse(source) = Representer::Engine::Grammar["typescript"].parse(Representer::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = TypeScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(TypeScript::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
