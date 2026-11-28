require "test_helper"

class RocTest < RosettaTest
  track "roc"

  def test_comments_and_layout_are_ignored
    commented = <<~ROC
      ## Says whether the year is a leap year.
      Leap :: {}.{
          is_leap_year : U64 -> Bool
          is_leap_year = |year| # the year to check
              year % 4 == 0
      }
    ROC
    plain = "Leap :: {}.{\n  is_leap_year : U64 -> Bool\n  is_leap_year = |year| year % 4 == 0\n}\n"
    assert_same_representation commented, plain
  end

  def test_imports_are_dropped
    assert_same_representation "import Helpers exposing [shout]\nf = |x| x\n", "f = |x| x\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "is_leap_year = |year| year % 4 == 0\n", "check = |y| y % 4 == 0\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "f = |s| s.trim()\n", "f = |s| s.trim_start()\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "f = |a, b| a + b\n", "f = |a, b| a - b\n"
    refute_same_representation "f = |a| \"a\"\n", "f = |a| \"b\"\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f = |a| (a +\n"
  end
end
