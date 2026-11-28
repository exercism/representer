require "test_helper"

# Runs Elm's stages by hand, for the tests of each stage.
module ElmStages
  Elm = Inspector::Languages::Elm

  def parse(source) = Inspector::Engine::Grammar["elm"].parse(Inspector::Engine.clean(source))

  # GenerateAST's tree for the source.
  def generate_ast(source) = Elm::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Elm::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # The code as the body of a function in a module.
  def wrap(body) = "module M exposing (f)\n\nf x y =\n#{body.gsub(/^/, '    ')}\n"
end
