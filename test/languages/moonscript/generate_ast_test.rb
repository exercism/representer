require_relative "stage_helper"

# Tests MoonScript's GenerateAST stage. Each assert_same pair has the same
# tree from MoonScript's parser, and each refute_same pair has different
# trees.
class MoonscriptGenerateASTTest < Minitest::Test
  include MoonscriptStages

  def test_brackets_that_only_group_are_dropped
    assert_same "x = (a + b) * (c)", "x = (a + b) * c"
    assert_same "x = a or (b and c)", "x = a or b and c"
    refute_same "x = (a + b) * c", "x = a + b * c"
  end

  def test_brackets_around_a_call_or_varargs_stay
    refute_same "x = (f!)", "x = f!"
    refute_same "f = (...) -> (...)", "f = (...) -> ..."
  end

  def test_calls_are_the_same_with_or_without_brackets
    assert_same "f a, b", "f(a, b)"
    assert_same "f!", "f()"
    assert_same "x\\y!", "x\\y()"
    refute_same "f (a), b", "f(a), b"
    refute_same "a.b!", "a\\b!"
  end

  def test_a_body_on_the_same_line_is_a_block
    assert_same "if a then b", "if a\n  b"
    assert_same "if a then b else c", "if a\n  b\nelse\n  c"
    assert_same "while a do f!", "while a\n  f!"
    assert_same "for i = 1, 3 do f i", "for i = 1, 3\n  f i"
    assert_same "f = (x) -> x", "f = (x) ->\n  x"
    assert_same "switch x\n  when 1 then a", "switch x\n  when 1\n    a"
  end

  def test_an_empty_parameter_list_makes_no_difference
    assert_same "f = () -> 1", "f = -> 1"
    refute_same "f = -> 1", "f = => 1"
  end

  def test_one_parameter_in_brackets_starts_a_function
    assert_same "f = (x) ->\n  x", "f = (x) -> x"
    assert_same "{\n  hey: (x) ->\n    x\n}", "hey: (x) ->\n  x"
    refute_same "f = (x) ->\n  x", "f = x ->\n  x"
  end

  def test_tables_are_the_same_however_they_are_written
    assert_same "x = {a: 1, b: 2}", "x = a: 1, b: 2"
    assert_same "x = {a: 1, b: 2}", "x =\n  a: 1\n  b: 2"
    assert_same "x = {\n  1\n  2\n}", "x = {1, 2,}"
    assert_same "f x, {a: 1}", "f x, a: 1"
    assert_same "x = { :count }", "x = { count: count }"
    refute_same "x = {[k]: 1}", "x = {k: 1}"
    refute_same 'x = {"k": 1}', "x = {k: 1}"
    refute_same "f {a: 1}, {b: 2}", "f a: 1, b: 2"
  end

  def test_the_bounds_of_a_slice_stay_apart
    refute_same "x = a[2,]", "x = a[,2]"
    refute_same "x = a[2]", "x = a[2,]"
  end

  def test_strings_are_written_as_their_values
    assert_same "x = 'a'", 'x = "a"'
    assert_same "x = [[a]]", 'x = "a"'
    assert_same "x = [==[\na]==]", 'x = "a"'
    assert_same "x = 'it\\'s'", %q(x = "it's")
    assert_same "x = 'a\\nb'", %(x = "a\\nb")
    refute_same %(x = "a \#{b}"), "x = 'a \#{b}'"
    refute_same "x = 'a\\qb'", "x = 'aqb'"
    refute_same "x = [[a\\n]]", "x = 'a\\n'"
  end

  def test_numbers_are_written_as_their_values
    assert_same "x = 0x1F", "x = 31"
    assert_same "x = .5", "x = 0.5"
    refute_same "x = 1.0", "x = 1"
  end

  def test_operators_stay_apart
    refute_same "x = a + b", "x = a - b"
    refute_same "x = a != b", "x = a == b"
    refute_same "x += 1", "x -= 1"
    refute_same "x = -a", "x = #a"
  end

  def test_constructors_and_metamethods_keep_their_names
    assert_equal ["reserved_key"], types_of_keys("class A\n  new: => 1")
    assert_equal ["reserved_key"], types_of_keys("x = { __index: y }")
    assert_equal ["property_identifier"], types_of_keys("x = { new: y }")
  end

  private
  def types_of_keys(source)
    keys = []
    generate_ast(source).each_descendant { |node| keys << node[:key].type if node.type == "pair" }
    keys
  end

  def assert_same(one, other) = assert_equal(write(generate_ast(one)), write(generate_ast(other)))

  def refute_same(one, other) = refute_equal(write(generate_ast(one)), write(generate_ast(other)))
end
