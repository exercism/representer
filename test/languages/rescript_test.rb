require "test_helper"

class RescriptTest < RosettaTest
  track "rescript"

  def test_comments_and_layout_are_ignored
    assert_same_representation "// Says one.\nlet f = () =>\n  1 /* one */\n", "let f = () => 1"
  end

  def test_opens_are_dropped
    assert_same_representation "open Belt\nlet f = xs => Array.length(xs)\n", "let f = xs => Array.length(xs)\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "let isLeapYear = year => divides(year, 4)\nlet divides = (n, d) => mod(n, d) == 0\n",
      "let leap = y => by(y, 4)\nlet by = (a, b) => mod(a, b) == 0\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "let f = xs => Math.max(xs)", "let f = xs => Math.min(xs)"
  end

  def test_interface_files_are_ignored
    with_interface = Rosetta::RepresentSolution.(track, { "Leap.res" => "let f = x => x\n", "Leap.resi" => "let f: int => int\n" })
    assert_equal represent("let f = x => x\n").representation, with_interface.representation
  end

  def test_things_that_must_stay_apart
    refute_same_representation "let f = x => x + 1", "let f = x => x - 1"
    refute_same_representation "let f = (a, b) => a - b", "let f = (a, b) => b - a"
    refute_same_representation "let f = (a, b) => a == b", "let f = (a, b) => a === b"
    refute_same_representation "let f = x => x->g", "let f = x => g(x)"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "let f = x => \"x"
  end
end
