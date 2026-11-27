require_relative "stage_helper"

# Tests Gleam's GenerateAST stage. Each assert_same pair is code that Gleam's
# parser reads as the same tree, and each refute_same pair is code that it
# reads as different trees.
class GleamGenerateASTTest < Minitest::Test
  include GleamStages

  def test_drops_comments
    assert_same "//// module\n/// doc\npub fn f() {\n  // note\n  1\n}\n", "pub fn f() {\n\n  1\n\n}\n"
  end

  def test_drops_brackets_commas_and_formatting
    assert_same "pub fn f(a, b,) { [1, 2,] }", "pub fn f(a, b) {\n  [\n    1,\n    2\n  ]\n}"
  end

  def test_keeps_let_and_let_assert_apart
    refute_same wrap("let [y] = [x]\ny"), wrap("let assert [y] = [x]\ny")
  end

  def test_numbers_are_their_values
    assert_same wrap("1_000 + 0x1F + 0b1"), wrap("1000 + 31 + 1")
    assert_same wrap("1_0.5"), wrap("10.5")
    assert_same wrap("1.50 +. 1.0e3"), wrap("1.5 +. 1000.0")
    refute_same wrap("1000"), wrap("100")
    refute_same wrap("1.0"), wrap("1")
  end

  def test_strings_are_their_values
    assert_same wrap('"a\\nb"'), wrap("\"a\nb\"")
    assert_same wrap('"\\u{41}"'), wrap('"A"')
    assert_includes ast(wrap('"a\\tb"')), '"a\tb"'
    refute_same wrap('"a"'), wrap('"b"')
  end

  def test_label_shorthands_are_written_in_full
    assert_same wrap("greet(name: \"x\", age:)"), wrap("greet(name: \"x\", age: age)")
    assert_same wrap("let Circle(radius:) = x\nradius"), wrap("let Circle(radius: radius) = x\nradius")
  end

  def test_variables_bound_by_patterns_are_marked
    assert_includes ast(wrap("let y = x\ny")), "(variable y)"
    assert_includes ast(wrap("let assert [h, ..t] = x\nh")), "(list_pattern (variable h)"
    assert_includes ast(wrap("use z <- g(x)\nz")), "(use_assignment (variable z))"
    assert_includes ast(wrap("case x { Ok(#(p, q)) -> p\n _ -> 0 }")), "(tuple_pattern # (variable p) (variable q))"
  end

  def test_the_module_of_a_constructor_in_a_pattern_is_not_a_variable
    tree = ast(wrap("case x { option.Some(v) -> v\n _ -> 0 }"))
    assert_includes tree, "(remote_constructor_name option . Some)"
    assert_includes tree, "(variable v)"
  end

  private
  def ast(source) = write(generate_ast(source)).gsub(/\s+/, " ")
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
