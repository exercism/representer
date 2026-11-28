require "test_helper"

# Runs MoonScript's stages by hand, for the tests of each stage.
module MoonscriptStages
  Moonscript = Inspector::Languages::Moonscript

  def parse(source)
    Inspector::Engine::Grammar["moonscript"].parse(Inspector::Engine.clean(source),
                                                   **Moonscript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Moonscript::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Moonscript::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
