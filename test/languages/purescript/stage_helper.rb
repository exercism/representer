require "test_helper"

# Runs PureScript's stages by hand, for the tests of each stage.
module PureScriptStages
  PureScript = Rosetta::Languages::PureScript

  def parse(source)
    Rosetta::Engine::Grammar["purescript"].parse(Rosetta::Engine.clean(source), **PureScript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = PureScript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(PureScript::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as a module with one declaration.
  def in_module(code) = "module Leap where\n\n#{code}\n"
end
