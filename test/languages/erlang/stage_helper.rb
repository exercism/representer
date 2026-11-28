require "test_helper"

# Runs Erlang's stages by hand, for the tests of each stage.
module ErlangStages
  Erlang = Rosetta::Languages::Erlang

  def parse(source)
    Rosetta::Engine::Grammar["erlang"].parse(Rosetta::Engine.clean(source), **Erlang::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Erlang::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Erlang::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as a module with one function.
  def in_module(code) = "-module(leap).\n-export([f/1]).\n\n#{code}\n"
end
