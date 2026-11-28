require "test_helper"

class CFMLTest < RosettaTest
  track "cfml"

  def test_comments_and_layout_are_ignored
    assert_same_representation "/** Says hello. */\ncomponent {\n  // Add one.\n  function f(x) {\n    return x + 1;\n  }\n}\n",
                               "component { function f(x) { return x + 1 } }"
  end

  def test_imports_are_dropped
    assert_same_representation "import com.example.Shape;\ncomponent { function f() { return 1; } }",
                               "component { function f() { return 1; } }"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "component { function leapYear(year) { return year % 4 == 0; } }",
                               "component { function isLeap(y) { return Y % 4 == 0; } }"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "component { function f(s) { return ucase(s); } }",
                               "component { function f(s) { return lcase(s); } }"
    refute_same_representation "component { function f(s) { return s.len(); } }",
                               "component { function f(s) { return s.size(); } }"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "component { function f(x) { return x + 1; } }",
                               "component { function f(x) { return x - 1; } }"
    refute_same_representation "component { function f(a, b) { return a - b; } }",
                               "component { function f(a, b) { return b - a; } }"
    refute_same_representation "component { function f(x) { var y = x; return y; } }",
                               "component { function f(x) { y = x; return y; } }"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "component { function f( {"
  end
end
