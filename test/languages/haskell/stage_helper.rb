require "test_helper"

# Runs Haskell's stages by hand, for the tests of each stage.
module HaskellStages
  Haskell = Representer::Languages::Haskell

  def parse(source)
    Representer::Engine::Grammar["haskell"].parse(Representer::Engine.clean(source), **Haskell::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Haskell::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Haskell::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)

  # The source as a module with one declaration.
  def in_module(code) = "module Leap (f) where\n\n#{code}\n"
end
