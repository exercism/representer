require "test_helper"

# Runs JavaScript's stages by hand, for the tests of each stage.
module JavaScriptStages
  JavaScript = Inspector::Languages::JavaScript

  def parse(source) = Inspector::Engine::Grammar["javascript"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = JavaScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(JavaScript::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
