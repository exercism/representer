require_relative "stage_helper"

# Tests Unison's GenerateAST stage. Each assert_same pair has the same
# meaning in Unison, and each refute_same pair has different meanings.
class UnisonGenerateASTTest < Minitest::Test
  include UnisonStages

  def test_the_grouping_of_arguments_stays
    refute_same "f = g (h x) y", "f = g h x y"
    refute_same "f = g (h x) y", "f = g (h x y)"
    refute_same "f = g (h x y)", "f = g h (x y)"
    refute_same "f = (g h) x", "f = g (h x)"
    refute_same "f = g (x -> x + 1) y", "f = g x -> x + 1 y"
    refute_same "f = g (if a then b else c) d", "f = g if a then b else c d"
  end

  def test_the_grouping_of_operators_stays
    refute_same "f = (a + b) * c", "f = a + b * c"
    refute_same "f = a - (b - c)", "f = a - b - c"
    refute_same "f = g (a + b)", "f = g a + b"
  end

  def test_an_operator_in_brackets_stays_a_function
    refute_same "f = List.foldLeft (+) 0 xs", "f = List.foldLeft + 0 xs"
    refute_same "f = map (Nat.+) xs", "f = map Nat.+ xs"
    refute_same "f = (g (+) 1)", "f = (g + 1)"
    assert_same "f = List.foldLeft ((+)) 0 xs", "f = List.foldLeft (+) 0 xs"
  end

  def test_a_tuple_stays_apart_from_brackets
    refute_same "f = (g, x)", "f = (g x)"
    refute_same "f = ((a, b))", "f = (a, b) c"
  end

  def test_the_parts_of_a_lambda_stay_apart
    refute_same "f = x -> y z", "f = x y -> z"
  end

  def test_the_parts_of_a_type_stay_apart
    refute_same "f : A B -> C\nf = g", "f : A -> B C\nf = g"
    refute_same "f : '{IO} ()\nf = g", "f : IO ()\nf = g"
    refute_same "f : (a -> b) -> c\nf = g", "f : a -> b -> c\nf = g"
  end

  def test_statements_stay_apart
    refute_same "f =\n  g x\n  h y", "f =\n  g x h y"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "f = g (x) y", "f = g x y"
    assert_same "f = (a + b)", "f = a + b"
    assert_same "f = ((g x))", "f = g x"
    assert_same "f = cases\n  (Some x) -> x", "f = cases\n  Some x -> x"
    assert_same "f = cases\n  x\n    | (x > 0) -> 1\n    | otherwise -> 0", "f = cases\n  x\n    | x > 0 -> 1\n    | otherwise -> 0"
    assert_same "f : (Nat) -> Nat\nf = g", "f : Nat -> Nat\nf = g"
  end

  def test_numbers_are_their_values
    assert_same "f = 0x1f", "f = 31"
    assert_same "f = 1.50", "f = 1.5"
    assert_same "f = 1e3", "f = 1000.0"
    assert_same "f = -0", "f = +0"
    refute_same "f = 1", "f = +1"
    refute_same "f = 1", "f = 1.0"
    refute_same "f = +1", "f = -1"
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n"], literals('f = "a\\tb\\n"')
    refute_same 'f = "a"', 'f = "b"'
    refute_same 'f = "a"', "f = ?a"
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'f = "\\x41"', 'f = "\\\\x41"'
  end

  def test_delayed_spellings_stay_apart
    refute_same "f = 'g", "f = do g"
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def assert_same(one, other) = assert_equal(write(generate_ast(one)), write(generate_ast(other)))

  def refute_same(one, other) = refute_equal(write(generate_ast(one)), write(generate_ast(other)))
end
