require "test_helper"

# Tests the whole Gleam representer. Each stage has its own tests in
# test/languages/gleam/.
class GleamTest < RepresenterTest
  track "gleam"

  def wrap(body) = "pub fn f(x: Int) -> Int {\n#{body}\n}\n"

  def test_formatting_makes_no_difference
    assert_same_representation "pub fn f(a, b,) { [1, 2,] }", "pub fn f(a, b) {\n  [\n    1,\n    2\n  ]\n}"
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation wrap("let y = x\ny"), wrap("let z = x\nz")
    assert_same_representation "pub fn f(a) { a }", "pub fn g(b) { b }"
  end

  def test_pattern_variables_are_renamed
    assert_same_representation "pub fn f(xs) { let assert [h, ..t] = xs\n h }", "pub fn f(xs) { let assert [a, ..b] = xs\n a }"
    assert_same_representation "pub fn f(xs) { case xs { Ok(#(p, q)) -> p\n _ -> 0 } }",
      "pub fn f(xs) { case xs { Ok(#(a, b)) -> a\n _ -> 0 } }"
    assert_same_representation "pub fn f(xs) { use z <- g(xs)\n z }", "pub fn f(xs) { use w <- g(xs)\n w }"
  end

  def test_labelled_argument_shorthand
    assert_same_representation "pub fn f(age) { greet(name: \"x\", age:) }", "pub fn f(age) { greet(name: \"x\", age: age) }"
    assert_same_representation "pub fn f(c) { let Circle(radius:) = c\n radius }",
      "pub fn f(c) { let Circle(radius: radius) = c\n radius }"
  end

  def test_types_and_constructors_are_renamed
    assert_same_representation "pub type Shape {\n  Circle(Float)\n}\npub fn f() { Circle(1.0) }",
      "pub type Form {\n  Disc(Float)\n}\npub fn f() { Disc(1.0) }"
  end

  def test_record_fields_are_renamed_where_they_are_used
    code = "pub type P {\n  P(%s: Int)\n}\npub fn f(p: P) { p.%s }"
    assert_same_representation format(code, "age", "age"), format(code, "years", "years")
  end

  def test_names_that_are_not_defined_are_kept
    refute_same_representation wrap("list.length([])"), wrap("list.reverse([])")
    refute_same_representation wrap("foo(x)"), wrap("bar(x)")
  end

  def test_function_labels_are_kept
    code = "pub fn f(%s a: Int) { a }"
    refute_same_representation format(code, "name"), format(code, "title")
  end

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "pub fn f( {"
  end
end
