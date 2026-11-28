require "test_helper"

class FutharkTest < RosettaTest
  track "futhark"

  def test_comments_and_layout_are_ignored
    assert_same_representation "-- Says hello.\ndef f: i32 = 1 -- one\n", "def f: i32 =\n  1\n"
  end

  def test_imports_and_opens_are_dropped
    assert_same_representation "import \"lib/github.com/diku-dk/sorts/merge_sort\"\nopen i32\n\ndef f x = x\n",
      "def f x = x\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "def is_leap (year: i32): bool = year % 4 == 0\n",
      "def leap (y: i32): bool = y % 4 == 0\n"
    assert_same_representation "type shape = #circle f64\ndef f (s: shape) = match s case #circle r -> r\n",
      "type form = #round f64\ndef f (s: form) = match s case #round x -> x\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "def f xs = i32.sum xs\n", "def f xs = i32.product xs\n"
    refute_same_representation "def f xs = map i32.abs xs\n", "def f xs = map i32.sgn xs\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "def f x = x + 1\n", "def f x = x - 1\n"
    refute_same_representation "def f a b = a - b\n", "def f a b = b - a\n"
    refute_same_representation "def f x = g (h x) 1\n", "def f x = g h x 1\n"
    refute_same_representation "def f = 1i32\n", "def f = 1i64\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "def f = (\n"
  end
end
