require "test_helper"

class MoonscriptTest < RosettaTest
  track "moonscript"

  def test_comments_and_layout_are_ignored
    assert_same_representation "-- Says hello.\nf = (x) -> x -- one\n", "f = (x) ->\n  x\n"
  end

  def test_imports_are_dropped
    assert_same_representation "import fold from require 'moon'\nList = require 'pl.List'\nf = -> 1\n",
      "f = -> 1\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "is_leap = (year) -> year % 4 == 0\n{ :is_leap }\n",
      "leap = (y) -> y % 4 == 0\n{ leap: leap }\n"
    assert_same_representation "class Account\n  new: => @balance = 0\n",
      "class Bank\n  new: => @total = 0\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "f = (t) -> table.concat t\n", "f = (t) -> table.insert t\n"
    refute_same_representation "f = (s) -> s\\upper!\n", "f = (s) -> s\\lower!\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "f = (x) -> x + 1\n", "f = (x) -> x - 1\n"
    refute_same_representation "f = (a, b) -> a - b\n", "f = (a, b) -> b - a\n"
    refute_same_representation "f = (x) -> x\n", "f = (x) => x\n"
    refute_same_representation "class A\n  new: => 1\n", "class A\n  init: => 1\n"
    refute_same_representation "x = { __eq: f }\n", "x = { __lt: f }\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f = (\n"
  end
end
