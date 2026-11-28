require "test_helper"

# Runs PowerShell's stages by hand, for the tests of each stage.
module PowershellStages
  Powershell = Inspector::Languages::Powershell

  def parse(source)
    Inspector::Engine::Grammar["powershell"].parse(Inspector::Engine.clean(source), **Powershell::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Powershell::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Powershell::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
