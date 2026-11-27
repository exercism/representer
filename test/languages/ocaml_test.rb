require "test_helper"

class OCamlTest < RepresenterTest
  track "ocaml"

  def test_comments_and_layout_are_ignored
    assert_same_representation "(** Says hello. *)\nlet f x =\n  (* add one *)\n  x + 1;;\n", "let f x = x + 1"
  end

  def test_imports_are_dropped
    assert_same_representation "open Base\nopen! Core\n\nlet f = List.rev\n", "let f = List.rev\n"
  end

  def test_local_opens_stay
    refute_same_representation "let f xs = let open List in rev xs", "let f xs = rev xs"
    refute_same_representation "let f xs = List.(rev xs)", "let f xs = Array.(rev xs)"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "let leap_year year =\n  let divisible_by n = year mod n = 0 in\n  divisible_by 4\n",
      "let leap_year y =\n  let d k = y mod k = 0 in\n  d 4\n"
    assert_same_representation "type shape = Circle of float\nlet area (Circle r) = r *. r",
      "type form = Round of float\nlet area (Round x) = x *. x"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "let f = List.map succ", "let f = List.map pred"
    refute_same_representation "let f = List.map succ", "let f = Array.map succ"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "let f x = x + 1", "let f x = x - 1"
    refute_same_representation "let f x = x <> 1", "let f x = x = 1"
    refute_same_representation "let f a b = a - b", "let f a b = b - a"
    refute_same_representation "let f = `A", "let f = `B"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "let f = (\n"
  end
end
