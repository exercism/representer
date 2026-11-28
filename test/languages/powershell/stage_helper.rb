require "test_helper"

# Runs PowerShell's stages by hand, for the tests of each stage.
module PowershellStages
  Powershell = Rosetta::Languages::Powershell

  def parse(source)
    Rosetta::Engine::Grammar["powershell"].parse(Rosetta::Engine.clean(source), **Powershell::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Powershell::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Powershell::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
