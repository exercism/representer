require_relative "stage_helper"

# Checks SQLite's declarations of which nodes are names and which nodes
# define them (see sqlite/representation/spec.rb), through the engine's
# renaming.
class SqliteNamesTest < Minitest::Test
  include SqliteStages

  def test_renames_the_tables_views_triggers_and_indexes_the_solution_creates
    source = "CREATE TABLE a (b INT, c TEXT);\nCREATE VIEW d AS SELECT 1;\n" \
             "CREATE TRIGGER e AFTER INSERT ON t BEGIN DELETE FROM a; END;\nCREATE INDEX f ON a (b)"
    assert_equal %w[a b c d e f], renamed(source)
  end

  def test_renames_common_table_expressions_and_their_columns
    source = "WITH RECURSIVE a(b, c) AS (SELECT 1, 2 UNION ALL SELECT b + 1, c FROM a WHERE b < 5) " \
             "SELECT b FROM a"
    assert_equal %w[a b c], renamed(source)
  end

  def test_renames_aliases
    assert_equal %w[a b], renamed("SELECT count(*) AS a FROM t b WHERE b.x = 1")
    assert_equal %w[a], renamed("SELECT value FROM json_each(t.x) AS a")
  end

  def test_renames_a_name_whatever_its_case
    assert_equal %w[a], renamed("WITH A AS (SELECT 1) SELECT * FROM a")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal [], renamed("UPDATE twofer SET response = 'One for ' || coalesce(input, 'you') || ', one for me.'")
    assert_equal [], renamed("SELECT key, value FROM json_each(input)")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Sqlite::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Sqlite::Representation::Spec.name?(node) }
    leaves
  end
end
