require "test_helper"

# Runs Haskell's stages by hand, for the tests of each stage.
module HaskellStages
  Haskell = Rosetta::Languages::Haskell

  def parse(source)
    Rosetta::Engine::Grammar["haskell"].parse(Rosetta::Engine.clean(source), **Haskell::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Haskell::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Haskell::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)

  # The source as a module with one declaration.
  def in_module(code) = "module Leap (f) where\n\n#{code}\n"
end
