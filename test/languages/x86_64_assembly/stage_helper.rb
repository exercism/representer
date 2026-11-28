require "test_helper"

# Runs x86-64 assembly's stages by hand, for the tests of each stage.
module X8664AssemblyStages
  X8664Assembly = Rosetta::Languages::X8664Assembly

  def parse(source)
    Rosetta::Engine::Grammar["x86_64_assembly"].parse(Rosetta::Engine.clean(source),
                                                        **X8664Assembly::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = X8664Assembly::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(X8664Assembly::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
