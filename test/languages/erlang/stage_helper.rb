require "test_helper"

# Runs Erlang's stages by hand, for the tests of each stage.
module ErlangStages
  Erlang = Inspector::Languages::Erlang

  def parse(source)
    Inspector::Engine::Grammar["erlang"].parse(Inspector::Engine.clean(source), **Erlang::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Erlang::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Erlang::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # The source as a module with one function.
  def in_module(code) = "-module(leap).\n-export([f/1]).\n\n#{code}\n"
end
