require "test_helper"

class UnisonTest < RosettaTest
  track "unison"

  def test_comments_documentation_and_layout_are_ignored
    assert_same_representation "{{ Says hello. }}\nf : Nat\nf = 1 -- one\n\n---\nnotes\n",
      "f : Nat\nf =\n  1\n"
  end

  def test_imports_are_dropped
    assert_same_representation "use Nat mod\n\nf n = mod n 2\n", "f n =\n  use Nat mod\n  mod n 2\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "leap.leap year =\n  divBy n = Nat.mod year n == 0\n  divBy 4\n",
      "leap.leap y =\n  d k = Nat.mod y k == 0\n  d 4\n"
    assert_same_representation "type Shape = Circle Float\nf : Shape -> Float\nf = cases Circle r -> r\n",
      "type Form = Round Float\nf : Form -> Float\nf = cases Round x -> x\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "f = List.map Nat.increment\n", "f = List.map Nat.decrement\n"
    refute_same_representation "f = cases\n  Less -> 1\n  Greater -> 2\n", "f = cases\n  Greater -> 1\n  Less -> 2\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "f x = x + 1\n", "f x = x - 1\n"
    refute_same_representation "f a b = a - b\n", "f a b = b - a\n"
    refute_same_representation "f x = g (h x) 1\n", "f x = g h x 1\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f = (\n"
  end
end
