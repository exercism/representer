require "test_helper"

# Runs SQLite's stages by hand, for the tests of each stage.
module SqliteStages
  Sqlite = Rosetta::Languages::Sqlite

  def parse(source)
    Rosetta::Engine::Grammar["sql"].parse(Rosetta::Engine.clean(source), **Sqlite::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Sqlite::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(Sqlite::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
