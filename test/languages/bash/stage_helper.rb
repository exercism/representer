require "test_helper"

# Runs Bash's stages by hand, for the tests of each stage.
module BashStages
  Bash = Inspector::Languages::Bash

  def parse(source)
    Inspector::Engine::Grammar["bash"].parse(Inspector::Engine.clean(source), **Bash::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Bash::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Bash::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
