require "test_helper"

# Runs Free Pascal's stages by hand, for the tests of each stage.
module FreePascalStages
  FreePascal = Rosetta::Languages::FreePascal

  # Each snippet is code inside a unit's implementation.
  def unit(code) = "unit u;\ninterface\nimplementation\n#{code}\nend.\n"

  def parse(code)
    Rosetta::Engine::Grammar["pascal"].parse(Rosetta::Engine.clean(unit(code)),
                                               **FreePascal::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the code.
  def generate_ast(code) = FreePascal::Common::GenerateAST.(parse(code))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(code) = Rosetta::Engine::PrepareFile.(FreePascal::Common::Spec, unit(code))

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
