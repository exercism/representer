require "test_helper"

class CutRangesTest < Minitest::Test
  def cut(source, ranges) = Representer::Engine::CutRanges.(source, ranges)

  def test_cuts_the_ranges_out_of_their_lines
    assert_equal ["x = 1\n", "y = 2\n"], cut("x = 1 # One\ny = 2\n", [6...11])
  end

  def test_gives_nil_for_a_line_with_nothing_left
    assert_equal [nil, "y = 2\n"], cut("# One\ny = 2\n", [0...5])
  end

  def test_joins_overlapping_ranges_in_any_order
    assert_equal ["a\n", nil, "d\n"], cut("a\nbc\nd\n", [3...4, 2...3])
  end

  def test_cuts_across_lines
    assert_equal ["a\n", nil, "d\n"], cut("a /*\n*/\nd\n", [2...7])
  end
end
