require "test_helper"

# Runs Lua's stages by hand, for the tests of each stage.
module LuaStages
  Lua = Representer::Languages::Lua

  def parse(source) = Representer::Engine::Grammar["lua"].parse(Representer::Engine.clean(source), **Lua::Common::Spec.parse_options)

  # GenerateAST's tree for the source.
  def generate_ast(source) = Lua::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Lua::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  def wrap(body) = "local function f(a, b)\n#{body}\nend\n"
end
