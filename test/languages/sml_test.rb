require "test_helper"

class SmlTest < RepresenterTest
  track "sml"

  def test_comments_and_layout_are_ignored
    assert_same_representation "(* Says hello. *)\nfun f x =\n  (* add one *)\n  x + 1;\n", "fun f x = x + 1"
  end

  def test_imports_are_dropped
    assert_same_representation "open List\n\nval f = rev\n", "val f = rev\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "fun isLeapYear year =\n  let fun divisibleBy n = year mod n = 0\n  in divisibleBy 4 end\n",
      "fun leap y =\n  let fun d k = y mod k = 0\n  in d 4 end\n"
    assert_same_representation "datatype shape = Circle of real\nfun area (Circle r) = r * r",
      "datatype form = Round of real\nfun area (Round x) = x * x"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "val f = List.map Char.toUpper", "val f = List.map Char.toLower"
    refute_same_representation "val f = List.map Char.toUpper", "val f = Vector.map Char.toUpper"
    refute_same_representation "fun f true = 1 | f false = 0", "fun f false = 1 | f true = 0"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "fun f x = x + 1", "fun f x = x - 1"
    refute_same_representation "fun f x = x <> 1", "fun f x = x = 1"
    refute_same_representation "fun f a b = a - b", "fun f a b = b - a"
    refute_same_representation "fun f a b c = (a + b) * c", "fun f a b c = a + b * c"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "val f = (\n"
  end
end
