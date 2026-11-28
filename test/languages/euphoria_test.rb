require "test_helper"

class EuphoriaTest < RosettaTest
  track "euphoria"

  def test_comments_and_layout_are_ignored
    assert_same_representation "-- Says one.\nfunction f() /* one */\n  return 1 -- one\nend function\n",
      "function f()\nreturn 1\nend function\n"
  end

  def test_imports_are_dropped
    assert_same_representation "include std/math.e\npublic include std/sequence.e as seq\ninteger x = 1\n",
      "integer x = 1\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "public function leap(integer year)\n  return remainder(year, 4) = 0\nend function\n",
      "public function is_leap(integer y)\n  return remainder(y, 4) = 0\nend function\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "function f(sequence s)\n  return upper(s)\nend function\n",
      "function f(sequence s)\n  return lower(s)\nend function\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "x = a + 1\n", "x = a - 1\n"
    refute_same_representation "x = a - b\n", "x = b - a\n"
    refute_same_representation "integer x = 1\n", "atom x = 1\n"
    refute_same_representation "x = f(a,,b)\n", "x = f(a,b)\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "x = (\n"
  end
end
