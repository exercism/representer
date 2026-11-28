require_relative "stage_helper"

# Tests SQLite's GenerateAST stage. Each assert_same pair has the same meaning
# in SQLite, and each refute_same pair has different meanings.
class SqliteGenerateASTTest < Minitest::Test
  include SqliteStages

  def test_layout_makes_no_difference
    assert_same "UPDATE t SET a = f(1, 2);", "UPDATE t\nSET a = f(1,2)"
    assert_same "SELECT a FROM t;\nSELECT b FROM t;", "SELECT a FROM t; SELECT b FROM t"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "SELECT (a + b) FROM t", "SELECT a + b FROM t"
    refute_same "SELECT (a + b) * c FROM t", "SELECT a + b * c FROM t"
    refute_same "SELECT a FROM t WHERE b IN (1)", "SELECT a FROM t WHERE b = 1"
  end

  def test_keywords_are_read_in_any_case
    assert_same "update t set a = case when b is null then 1 else 2 end",
                "UPDATE t SET a = CASE WHEN b IS NULL THEN 1 ELSE 2 END"
    assert_same "CREATE TEMPORARY TABLE a (b INT)", "CREATE TEMP TABLE a (b INT)"
  end

  def test_keywords_that_tell_code_apart_stay
    refute_same "SELECT a FROM t UNION ALL SELECT a FROM t", "SELECT a FROM t UNION SELECT a FROM t"
    refute_same "SELECT DISTINCT a FROM t", "SELECT a FROM t"
    refute_same "SELECT a FROM t ORDER BY a DESC", "SELECT a FROM t ORDER BY a"
    refute_same "SELECT a FROM t LEFT JOIN u ON a = b", "SELECT a FROM t JOIN u ON a = b"
    refute_same "SELECT a FROM t WHERE a NOT IN (1, 2)", "SELECT a FROM t WHERE a IN (1, 2)"
    refute_same "SELECT a FROM t WHERE a IS NOT NULL", "SELECT a FROM t WHERE a IS NULL"
    refute_same "CREATE TABLE IF NOT EXISTS a (b INT)", "CREATE TABLE a (b INT)"
    refute_same "CREATE TABLE a (b INTEGER PRIMARY KEY)", "CREATE TABLE a (b INT PRIMARY KEY)"
    refute_same "CREATE TRIGGER a AFTER INSERT ON t BEGIN DELETE FROM t; END",
                "CREATE TRIGGER a AFTER UPDATE ON t BEGIN DELETE FROM t; END"
  end

  def test_both_forms_of_case_stay_apart
    refute_same "SELECT CASE a WHEN b THEN c END FROM t", "SELECT CASE WHEN a THEN b ELSE c END FROM t"
  end

  def test_keywords_that_sqlite_reads_as_no_keyword_are_dropped
    assert_same "WITH RECURSIVE a(b) AS (SELECT 1) SELECT b FROM a", "WITH a(b) AS (SELECT 1) SELECT b FROM a"
    assert_same "SELECT a FROM t INNER JOIN u ON a = b", "SELECT a FROM t JOIN u ON a = b"
    assert_same "SELECT a FROM t LEFT OUTER JOIN u ON a = b", "SELECT a FROM t LEFT JOIN u ON a = b"
    assert_same "SELECT a AS b FROM t", "SELECT a b FROM t"
  end

  def test_both_spellings_of_equals_and_not_equals_are_the_same
    assert_same "SELECT a FROM t WHERE a == 1", "SELECT a FROM t WHERE a = 1"
    assert_same "SELECT a FROM t WHERE a <> 1", "SELECT a FROM t WHERE a != 1"
    refute_same "SELECT a FROM t WHERE a != 1", "SELECT a FROM t WHERE a = 1"
  end

  def test_names_are_read_in_any_case
    assert_same "SELECT Upper(A) FROM T", "SELECT upper(a) FROM t"
    assert_same "SELECT `a` FROM t", "SELECT a FROM t"
    refute_same 'SELECT "A" FROM t', 'SELECT "a" FROM t'
  end

  def test_strings_are_their_values
    assert_includes ast("SELECT 'it''s'"), %("it's")
    refute_same "SELECT 'a'", "SELECT 'b'"
    refute_same "SELECT 'a'", 'SELECT "a"'
    refute_same "SELECT '1'", "SELECT 1"
  end

  def test_a_double_quoted_string_is_the_same_as_a_double_quoted_name
    assert_includes ast(%(INSERT INTO t VALUES ("a"))), %((quoted_identifier "a"))
    assert_includes ast(%(SELECT a FROM t WHERE b = "a")), %((quoted_identifier "a"))
    assert_includes ast(%(UPDATE "a" SET b = 1)), %((quoted_identifier "a"))
  end

  def test_other_literals_are_read_in_any_case
    assert_same "SELECT NULL, TRUE, X'FF'", "SELECT null, true, x'ff'"
    refute_same "SELECT TRUE", "SELECT 1"
  end

  def test_numbers_are_their_values
    assert_same "SELECT 0x1F, 1e3, .50, 007, -5", "SELECT 31, 1000.0, 0.5, 7, -5"
    refute_same "SELECT 1", "SELECT 1.0"
    refute_same "SELECT 1e3", "SELECT 1000"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
