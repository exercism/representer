require "test_helper"

# Runs TypeScript's stages by hand, for the tests of each stage.
module TypeScriptStages
  TypeScript = Rosetta::Languages::TypeScript

  def parse(source) = Rosetta::Engine::Grammar["typescript"].parse(Rosetta::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = TypeScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(TypeScript::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
