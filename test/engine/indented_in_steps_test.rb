require "test_helper"

class IndentedInStepsTest < Minitest::Test
  IndentedInSteps = Representer::Engine::IndentedInSteps

  def test_lines_may_move_in_or_out_by_one_step
    assert IndentedInSteps.("a\n  b\n    c\n  d\ne\n", 2)
    refute IndentedInSteps.("a\n    b\n", 2)
    refute IndentedInSteps.("a\n b\n", 2)
  end

  def test_blank_lines_are_ignored
    assert IndentedInSteps.("a\n\n   \n  b\n", 2)
  end

  def test_a_tab_is_not_a_step
    refute IndentedInSteps.("a\n\tb\n", 2)
  end
end
