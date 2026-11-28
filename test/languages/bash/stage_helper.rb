require "test_helper"

# Runs Bash's stages by hand, for the tests of each stage.
module BashStages
  Bash = Rosetta::Languages::Bash

  def parse(source)
    Rosetta::Engine::Grammar["bash"].parse(Rosetta::Engine.clean(source), **Bash::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Bash::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Bash::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
