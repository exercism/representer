require_relative "stage_helper"

# Tests Pyret's GenerateAST stage. Each assert_same pair has the same meaning
# in Pyret, and each refute_same pair has different meanings.
class PyretGenerateASTTest < Minitest::Test
  include PyretStages

  def test_layout_makes_no_difference
    assert_same "fun f(a, b):\n  a + b\nend", "fun f(a,b): a + b end"
    assert_same "x = [list: 1, 2,]", "x = [list: 1, 2]"
    assert_same "x = {1; 2;}", "x = {1; 2}"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "x = (a + b) + c", "x = a + b + c"
    assert_same "x = (f(a))", "x = f(a)"
    refute_same "x = a + (b + c)", "x = a + b + c"
    refute_same "x = (a and b) or c", "x = a and (b or c)"
  end

  def test_both_spellings_of_a_lambda_are_the_same
    assert_same "f = lam(x): x * 2 end", "f = {(x): x * 2}"
  end

  def test_the_bar_before_the_first_variant_makes_no_difference
    assert_same "data D: | a | b(x) end", "data D: a | b(x) end"
  end

  def test_keywords_that_change_the_meaning_stay
    refute_same "fun f(): 1 end", "fun f() block: 1 end"
    refute_same "check: 1 is 1 end", "examples: 1 is 1 end"
    refute_same "fun f(x): x end", "fun f(shadow x): x end"
    refute_same "data D: a(x) end", "data D: a(ref x) end"
    refute_same "{a; b} = t", "{a; b} as c = t"
    refute_same "{a; b; c} = t", "{a; b} as c = t"
    refute_same "check: a is%(f) b end", "check: a is b because f end"
    refute_same "check: a is b end", "check: a is-not b end"
    refute_same "x = a.b", "x = a!b"
    refute_same "x = true", "x = false"
  end

  def test_strings_are_their_values
    assert_same %(x = 'a"b'), %(x = "a\\"b")
    assert_same %(x = "a\\tb"), "x = \"a\tb\""
    assert_same "x = ```  a\n  b  ```", %(x = "a\\n  b")
    refute_same %(x = "a\\u0041"), %(x = "aA")
    refute_same %(x = "1"), "x = 1"
  end

  def test_numbers_are_their_values
    assert_same "x = 1.0 + 1e3 + 0.50", "x = 1 + 1000 + 0.5"
    refute_same "x = 1/2", "x = 0.5"
    refute_same "x = -1", "x = 1"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
