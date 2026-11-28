require_relative "stage_helper"

# Tests Futhark's GenerateAST stage. Each assert_same pair has the same
# meaning in Futhark, and each refute_same pair has different meanings.
class FutharkGenerateASTTest < Minitest::Test
  include FutharkStages

  def test_a_top_level_let_is_a_def
    assert_same "let f x = x", "def f x = x"
    refute_same "entry f x = x", "def f x = x"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "def f = (a + b) * c", "def f = (a + b) * (c)"
    assert_same "def f = a || (b && c)", "def f = a || b && c"
    assert_same "def f = (g a) b", "def f = g a b"
    assert_same "def f (x) = x", "def f x = x"
    assert_same "def f (xs: ([]i32)) = xs", "def f (xs: []i32) = xs"
    refute_same "def f = (a + b) * c", "def f = a + b * c"
    refute_same "def f = g (h x)", "def f = g h x"
  end

  def test_an_in_between_two_lets_makes_no_difference
    assert_same "def f = let a = 1 in let b = 2 in a + b", "def f = let a = 1 let b = 2 in a + b"
  end

  def test_a_trailing_comma_makes_no_difference
    assert_same "def f = [1, 2,]", "def f = [1, 2]"
    assert_same "def f = {a = 1, b = 2,}", "def f = {a = 1, b = 2}"
  end

  def test_a_return_type_stays_apart_from_a_parameter
    refute_same "def f x: () = x", "def f x () = x"
    refute_same "def f = let g x: () = x in g", "def f = let g x () = x in g"
    refute_same "def f = \\x: () -> x", "def f = \\x () -> x"
  end

  def test_an_index_stays_apart_from_a_name
    refute_same "def f a i = let a[i] = 1 in a", "def f a i = let a i = 1 in a"
    refute_same "def f a i = a with [i] = 1", "def f a i = a with i = 1"
    refute_same "def f = map (.[i]) xs", "def f = map (.i) xs"
    refute_same "def f = a[i:]", "def f = a[:i]"
    refute_same "def f = a[i, j]", "def f = a[i][j]"
  end

  def test_record_patterns_stay_apart
    refute_same "def f {a = b} = b", "def f {a, b} = b"
    refute_same "def f {a = ()} = a", "def f {a : ()} = a"
  end

  def test_ranges_stay_apart
    refute_same "def f = 1..<n", "def f = 1...n"
    refute_same "def f = 1..<n", "def f = 1..>n"
    refute_same "def f = 1..2...n", "def f = 1...n"
  end

  def test_the_kinds_of_types_stay_apart
    refute_same "type t = i32", "type^ t = i32"
    refute_same "type~ t = i32", "type^ t = i32"
    refute_same "def f 't (x: t) = x", "def f '^t (x: t) = x"
    refute_same "def f (xs: *[]i32) = xs", "def f (xs: []i32) = xs"
  end

  def test_local_stays
    refute_same "local def f x = x", "def f x = x"
  end

  def test_numbers_are_their_values
    assert_same "def f = 1_000", "def f = 1000"
    assert_same "def f = 0x1F", "def f = 31"
    assert_same "def f = 0b101", "def f = 5"
    assert_same "def f = 1.50", "def f = 1.5"
    assert_same "def f = 1e3", "def f = 1000.0"
  end

  def test_numbers_keep_their_types
    assert_same "def f = 0x80u32", "def f = 128u32"
    assert_same "def f = 1_000i64", "def f = 1000i64"
    assert_same "def f = 1.50f32", "def f = 1.5f32"
    assert_same "def f = 1f64", "def f = 1.0f64"
    refute_same "def f = 1i32", "def f = 1"
    refute_same "def f = 1i32", "def f = 1i64"
    refute_same "def f = 1u32", "def f = 1i32"
    refute_same "def f = 1", "def f = 1.0"
    refute_same "def f = 1.0f32", "def f = 1.0"
    refute_same "def f = 1.0f32", "def f = 1.0f64"
  end

  def test_strings_are_their_values
    assert_equal ["a\nb"], literals('def f = "a\\nb"')
    refute_same 'def f = "a"', 'def f = "b"'
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'def f = "a\\tb"', 'def f = "atb"'
    refute_same 'def f = "a\\tb"', 'def f = "a\\nb"'
  end

  def test_characters_stay_apart_from_strings
    refute_same "def f = 'a'", 'def f = "a"'
    refute_same "def f = ' '", %q(def f = "' '")
    refute_same "def f = '\\n'", "def f = 'n'"
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
