require_relative "stage_helper"

# Tests ReScript's GenerateAST stage. Each assert_same pair gets the same
# tree from ReScript's parser, and each refute_same pair does not.
class RescriptGenerateASTTest < Minitest::Test
  include RescriptStages

  def test_layout_makes_no_difference
    assert_same "let f = x =>\n  x + 1\n", "let f = x => x + 1;"
  end

  def test_brackets_that_only_group_make_no_difference
    assert_same "let f = x => (x * 2) / 3", "let f = x => x * 2 / 3"
    assert_same "let f = x => switch (x) { | _ => 1 }", "let f = x => switch x { | _ => 1 }"
    refute_same "let f = x => x * (2 / 3)", "let f = x => x * 2 / 3"
  end

  def test_a_parameter_without_brackets_is_the_same
    assert_same "let f = x => x", "let f = (x) => x"
    refute_same "let f = x => x", "let f = (x, y) => x"
  end

  def test_braces_around_one_expression_are_the_expression
    assert_same "let f = x => { x + 1 }", "let f = x => x + 1"
    assert_same "let f = x => switch x { | _ => { 1 } }", "let f = x => switch x { | _ => 1 }"
    refute_same "let f = x => { let y = x\n y }", "let f = x => x"
  end

  def test_punned_fields_and_labels_are_written_in_full
    assert_same "let r = {x, y: 1}", "let r = {x: x, y: 1}"
    assert_same "let {x, y: z} = r", "let {x: x, y: z} = r"
    assert_same "let _ = f(~x, ~y?)", "let _ = f(~x=x, ~y=?y)"
    refute_same "let {x, y} = r", "let {x: y, y: x} = r"
  end

  def test_when_in_a_guard_is_if
    assert_same "let f = x => switch x { | n when n > 1 => 1 | _ => 0 }",
                "let f = x => switch x { | n if n > 1 => 1 | _ => 0 }"
  end

  def test_numbers_are_their_values
    assert_same "let n = (1_000, 0xFF, 1.50, 1.)", "let n = (1000, 255, 1.5, 1.0)"
    refute_same "let n = 1", "let n = 1.0"
    refute_same "let n = 1n", "let n = 1"
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n\"c\""], literals('let s = "a\\tb\\n\\"c\\""')
    refute_same 'let s = "a"', 'let s = "b"'
    refute_same 'let s = "a"', "let s = `a`"
    refute_same "let s = 'a'", 'let s = "a"'
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'let s = "\\u0041"', 'let s = "\\\\u0041"'
  end

  def test_template_strings_keep_their_text
    refute_same "let s = `a ${x}`", "let s = `b ${x}`"
  end

  def test_operators_that_differ_stay_apart
    refute_same "let f = (a, b) => a == b", "let f = (a, b) => a === b"
    refute_same "let f = x => x->g", "let f = x => x |> g"
    refute_same "let f = (a, b) => a + b", "let f = (a, b) => a +. b"
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
