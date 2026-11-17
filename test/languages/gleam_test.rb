require "test_helper"

# The old gleam-representer was the Exercism template: it joined the solution
# files, removed blank lines and trailing whitespace, and never changed a name.
# Its golden tests are the template's F# examples (Leap.fs), so none of them
# can be ported. Everything below is new.
class GleamTest < RepresenterTest
  track "gleam"

  def wrap(body) = "pub fn f(x: Int) -> Int {\n#{body}\n}\n"

  ### Formatting ###

  def test_comments_and_blank_lines_are_dropped
    assert_same_representation "//// module\n/// doc\npub fn f() {\n  // note\n  1\n}\n", "pub fn f() {\n\n  1\n\n}\n"
  end

  def test_trailing_commas_and_formatting
    assert_same_representation "pub fn f(a, b,) { [1, 2,] }", "pub fn f(a, b) {\n  [\n    1,\n    2\n  ]\n}"
  end

  def test_numbers_with_underscores
    assert_same_representation wrap("1_000"), wrap("1000")
    assert_same_representation wrap("1_0.5"), wrap("10.5")
    refute_same_representation wrap("1000"), wrap("100")
  end

  def test_strings
    assert_same_representation wrap('"a\\nb"'), wrap("\"a\nb\"")
    assert_same_representation wrap('"\\u{41}"'), wrap('"A"')
    refute_same_representation wrap('"a"'), wrap('"b"')
  end

  def test_labelled_argument_shorthand
    assert_same_representation "pub fn f(age) { greet(name: \"x\", age:) }", "pub fn f(age) { greet(name: \"x\", age: age) }"
    assert_same_representation "pub fn f(c) { let Circle(radius:) = c\n radius }",
      "pub fn f(c) { let Circle(radius: radius) = c\n radius }"
  end

  ### Imports ###

  def test_imports_are_sorted
    assert_same_representation "import gleam/string\nimport gleam/list\n\npub fn f() { 1 }",
      "import gleam/list\nimport gleam/string\n\npub fn f() { 1 }"
    refute_same_representation "import gleam/string\n\npub fn f() { 1 }", "import gleam/list\n\npub fn f() { 1 }"
  end

  def test_unqualified_imports_are_sorted
    assert_same_representation "import gleam/list.{map, filter}", "import gleam/list.{filter, map}"
  end

  def test_import_aliases_are_renamed
    assert_same_representation "import gleam/list as l\npub fn f() { l.length([]) }",
      "import gleam/list as m\npub fn f() { m.length([]) }"
  end

  ### Names ###

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

  def test_main_keeps_its_name
    refute_same_representation "pub fn main() { 1 }", "pub fn go() { 1 }"
  end

  def test_names_the_tests_use_are_kept
    tests = "import leap\n\npub fn leap_test() {\n  leap.is_leap_year(2015)\n}\n"
    refute_same_representation "pub fn is_leap_year(y) { y }", "pub fn other(y) { y }",
      exercise_files: { "test/leap_test.gleam" => tests }
  end

  def test_syntax_errors_fall_back
    assert_falls_back "pub fn f( {"
  end
end
