require_relative "stage_helper"

# Tests R's GenerateAST stage, which gives one tree to code that differs
# only in comments, layout, brackets that only group and the spellings that
# R's parser reads the same way.
class RGenerateASTTest < Minitest::Test
  include RStages

  def test_drops_comments_and_layout
    assert_same "# c\nx <- 1 # x\n", "x<-1"
    assert_same "x <- 1; y <- 2", "x <- 1\ny <- 2"
    assert_same wrap("g(a,\n  b)"), wrap("g(a, b)")
  end

  def test_unwraps_brackets_that_only_group
    assert_same wrap("(a + b)"), wrap("a + b")
    refute_same wrap("(a + b) * a"), wrap("a + b * a")
  end

  def test_keeps_braces
    refute_same wrap("if (a) { b }"), wrap("if (a) b")
  end

  def test_keeps_the_place_of_arguments_left_out
    refute_same wrap("a[, 1]"), wrap("a[1, ]")
    refute_same wrap("a[1, ]"), wrap("a[1]")
    assert_same wrap("a[ , 1]"), wrap("a[,1]")
  end

  def test_keeps_arguments_with_a_name_and_no_value
    refute_same wrap("switch(a, x = , y = 1)"), wrap("switch(a, x, y = 1)")
  end

  def test_keeps_assignment_operators_apart
    refute_same "x <- 1", "x = 1"
    refute_same "x <- 1", "x <<- 1"
  end

  def test_right_assignments_are_left_assignments
    assert_same "1 -> x", "x <- 1"
    assert_same "1 ->> x", "x <<- 1"
  end

  def test_double_stars_are_carets
    assert_same wrap("a ** 2"), wrap("a ^ 2")
  end

  def test_lambdas_are_functions
    assert_same "f <- \\(x) x + 1", "f <- function(x) x + 1"
  end

  def test_pipes_are_calls
    assert_same wrap("a |> g(b)"), wrap("g(a, b)")
    assert_same wrap("a |> g() |> h()"), wrap("h(g(a))")
    assert_same wrap("a |> g(b, x = _)"), wrap("g(b, x = a)")
    refute_same wrap("a %>% g(b)"), wrap("g(a, b)")
  end

  def test_keeps_special_operators_apart
    refute_same wrap("a %% b"), wrap("a %/% b")
    refute_same wrap("a %in% b"), wrap("a %% b")
  end

  def test_names_in_backticks_and_quotes_are_names
    assert_same wrap("`g`(a)"), wrap("g(a)")
    assert_same wrap('list("x" = a)'), wrap("list(x = a)")
    assert_same wrap("list(`x` = a)"), wrap("list(x = a)")
    refute_same wrap('list("x")'), wrap("list(x)")
  end

  def test_numbers_are_their_values
    assert_same wrap("a + 1e3 + 0x10"), wrap("a + 1000 + 16")
    assert_same wrap("a + 1.0 + 1.50"), wrap("a + 1 + 1.5")
    assert_same wrap("a + 0x10L"), wrap("a + 16L")
    refute_same wrap("a + 1L"), wrap("a + 1")
    refute_same wrap("a + 1i"), wrap("a + 1")
  end

  def test_strings_are_their_values
    assert_same wrap("'it\\'s'"), wrap('"it\'s"')
    assert_same wrap('"a\\tb\\n"'), wrap("'a\\tb\\n'")
    assert_same wrap('r"(a\\n)"'), wrap("'a\\\\n'")
    assert_same wrap('R"[a]"'), wrap('"a"')
    refute_same wrap("'a'"), wrap("'b'")
    refute_same wrap('r"(a\\n)"'), wrap("'a\\n'")
  end

  def test_unknown_escapes_stay_as_they_are
    refute_same wrap("'\\x41'"), wrap("'A'")
    refute_same wrap("'\\u00e9'"), wrap("'é'")
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
