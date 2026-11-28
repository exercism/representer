require "test_helper"

class TidyLinesTest < Minitest::Test
  def tidy(lines) = Rosetta::Engine::TidyLines.(lines)

  def test_drops_nil_lines_and_blank_lines_at_the_top
    assert_equal %W[a\n b\n], tidy(["\n", " \n", "a\n", nil, "b\n"])
  end

  def test_turns_each_run_of_blank_lines_into_one
    assert_equal %W[a\n \n b\n], tidy(["a\n", "\n", nil, "  \n", "b\n"])
  end
end
