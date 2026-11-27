require_relative "stage_helper"

# Tests Nim's GenerateAST stage. Each assert_same pair is code that Nim's
# parser reads as the same tree, and each refute_same pair is code that it
# reads as different trees. The last test lists the pairs where this stage
# deliberately differs from the parser.
class NimGenerateASTTest < Minitest::Test
  include NimStages

  def test_drops_comments
    assert_same "# one\nproc f(x: int): int =\n  ## doc\n  #[ block ]#\n  x\n", "proc f(x: int): int =\n  x\n"
  end

  def test_drops_brackets_commas_and_semicolons
    assert_same "proc f(a: int; b: int): int = a + b", "proc f(a: int, b: int): int = a + b"
    assert_same "echo(1, 2,)", "echo 1, 2"
  end

  def test_commands_are_calls
    assert_same "echo \"a\", 1", "echo(\"a\", 1)"
  end

  def test_numbers_are_their_values
    assert_same wrap("1_000 + 0x1F"), wrap("1000 + 31")
    assert_same wrap("1.50"), wrap("1.5")
    assert_same wrap("1_000'i64"), wrap("1000'i64")
    refute_same wrap("1000"), wrap("100")
    refute_same wrap("1'i64"), wrap("1")
    refute_same wrap("1.0"), wrap("1")
  end

  def test_strings_are_their_text
    assert_includes ast("let x = \"ab\""), "\"ab\""
    refute_same "let x = \"a\\n\"", "let x = \"b\\n\""
    refute_same "let x = \"a\\n\"", "let x = \"a\""
  end

  def test_fmt_and_ampersand_strings_are_the_same
    assert_same wrap("fmt\"{x} and {y}\""), wrap("&\"{x} and {y}\"")
    assert_includes ast(wrap("fmt\"a {x.len:>3}\"")), "(interpolation x . len >3)"
    refute_same wrap("fmt\"{x}\""), wrap("fmt\"{y}\"")
    refute_same wrap("fmt\"{x:>3}\""), wrap("fmt\"{x:<3}\"")
  end

  def test_operators_are_calls
    assert_same wrap("x + y"), wrap("`+`(x, y)")
    assert_same wrap("not (x == y)"), wrap("`not`(`==`(x, y))")
    assert_same wrap("-x"), wrap("`-`(x)")
    refute_same wrap("x + y"), wrap("x - y")
    refute_same wrap("-x"), wrap("x - y")
  end

  def test_quoted_operators_are_operators
    assert_includes ast("proc `+`(a: int): int = a"), "(accent_quoted +)"
  end

  def test_a_routine_without_brackets_has_empty_brackets
    assert_same "proc f = discard", "proc f() = discard"
    assert_same "iterator f[T] = discard", "iterator f[T]() = discard"
  end

  def test_names_ignore_case_after_the_first_letter_and_underscores
    assert_same "echo helloWorld(1)", "echo hello_world(1)"
    assert_same "echo helloWorld(1)", "echo hELLOWORLD(1)"
    refute_same "echo Hello(1)", "echo hello(1)"
  end

  # The parser keeps a pair of brackets that only groups, and this stage
  # drops it. The tree's shape still shows the grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same "proc f(a: int, b: int): int = a + (b)", "proc f(a: int, b: int): int = a + b"
    refute_same "let x = (1 + 2) * 3", "let x = 1 + 2 * 3"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
