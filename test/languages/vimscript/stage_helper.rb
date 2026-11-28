require "test_helper"

# Runs Vimscript's stages by hand, for the tests of each stage.
module VimscriptStages
  Vimscript = Rosetta::Languages::Vimscript

  def parse(source)
    Rosetta::Engine::Grammar["vim"].parse(Rosetta::Engine.clean(source), **Vimscript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Vimscript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Vimscript::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
