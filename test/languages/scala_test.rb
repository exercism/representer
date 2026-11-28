require "test_helper"

class ScalaTest < InspectorTest
  track "scala"

  def test_comments_layout_and_imports_go
    assert_same_representation "object Leap { def leapYear(year: Int): Boolean = year % 4 == 0 }",
      "import scala.math.abs\n// A leap year\nobject Leap:\n  import java.util.Date\n" \
      "  def leapYear(year: Int): Boolean = year % 4 == 0 /* done */\n"
  end

  def test_names_the_solution_defines_are_renamed
    code = "object %s { case class %s(%s: Int)\n  def %s(%s: List[%s]): Int = %s.map { case %s(%s) => %s }.sum }"
    assert_same_representation format(code, "Leap", "Box", "n", "total", "xs", "Box", "xs", "Box", "v", "v"),
      format(code, "Year", "Item", "m", "count", "items", "Item", "items", "Item", "w", "w")
  end

  def test_names_from_the_library_keep_their_names
    refute_same_representation "object A { def f(xs: List[Int]) = xs.max }", "object A { def f(xs: List[Int]) = xs.min }"
    refute_same_representation "object A { def f(x: Option[Int]) = x match { case None => 0 } }",
      "object A { def f(x: Option[Int]) = x match { case Nil => 0 } }"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation 'object A { val x = 1_000; val y = """a""" }', 'object A { val x = 1000; val y = "a" }'
  end

  def test_syntax_errors_get_a_basic_representation_with_the_scala_version
    assert_basic_representation "object A { def f( = }"
  end
end
