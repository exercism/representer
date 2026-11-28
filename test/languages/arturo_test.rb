require "test_helper"

class ArturoTest < RosettaTest
  track "arturo"

  def test_comments_and_layout_are_ignored
    assert_same_representation "; Says one.\nf: function [][\n  1 ; one\n]\n",
      "f: function [][1]\n"
  end

  def test_imports_are_dropped
    assert_same_representation "import {unitt}!\nx: 1\n", "x: 1\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "leap?: function [year][\n  zero? year % 4\n]\n",
      "isLeap?: function [y][\n  zero? y % 4\n]\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "f: function [s][upper s]\n", "f: function [s][lower s]\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "x: a + 1\n", "x: a - 1\n"
    refute_same_representation "x: a - b\n", "x: b - a\n"
    refute_same_representation "x: 1\n", "x: 1.0\n"
    refute_same_representation "x: \\a\\b\n", "x: a\\b\n"
    refute_same_representation "f: function [x][x]\n", "f: method [x][x]\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "x: [\n"
  end
end
