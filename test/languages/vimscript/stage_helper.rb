require "test_helper"

# Runs Vimscript's stages by hand, for the tests of each stage.
module VimscriptStages
  Vimscript = Inspector::Languages::Vimscript

  def parse(source)
    Inspector::Engine::Grammar["vim"].parse(Inspector::Engine.clean(source), **Vimscript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Vimscript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Vimscript::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
