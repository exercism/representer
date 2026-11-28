require "test_helper"

class SwiftTest < InspectorTest
  track "swift"

  def wrap(body) = "func f(x: Int) -> Int {\n#{body}\n}\n"

  def test_comments_and_layout_are_ignored
    assert_same_representation "/// Docs\nfunc f() -> Int {\n    // note\n    return 1 /* one */\n}\n",
      "func f() -> Int {\n\n  return 1;\n\n}"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "func plus(_ a: Int, to b: Int) -> Int { a + b }",
      "func sum(_ x: Int, to y: Int) -> Int { x + y }"
    assert_same_representation "struct Point { var x: Int }\nfunc f(p: Point) -> Int { p.x }",
      "struct Spot { var a: Int }\nfunc f(p: Spot) -> Int { p.a }"
    assert_same_representation wrap("outer: for i in 0..<x { if i > 2 { break outer } }\nreturn x"),
      wrap("loop: for j in 0..<x { if j > 2 { break loop } }\nreturn x")
    refute_same_representation "enum C { case red, blue }\nlet c = C.red", "enum C { case red, blue }\nlet c = C.blue"
  end

  def test_names_from_outside_are_kept_if_the_solution_only_calls_them
    refute_same_representation wrap("return x.signum()"), wrap("return x.magnitude")
    refute_same_representation 'func f(s: String) -> String { s.uppercased() }',
      'func f(s: String) -> String { s.lowercased() }'
  end

  def test_things_that_must_stay_apart
    refute_same_representation wrap("return x + 1"), wrap("return x - 1")
    refute_same_representation wrap("return x &+ 1"), wrap("return x + 1")
    refute_same_representation wrap("return [x][0]"), wrap("return [x].first!")
    refute_same_representation 'let s = "a"', 'let s = "b"'
  end

  def test_imports_are_dropped
    assert_same_representation "import Foundation\nfunc f() { }", "func f() { }"
    refute_same_representation "import Foundation\nfunc f() -> Double { sqrt(2) }",
      "import Foundation\nfunc f() -> Double { cbrt(2) }"
  end

  def test_a_syntax_error_gets_a_basic_representation
    assert_basic_representation "func f( {"
  end
end
