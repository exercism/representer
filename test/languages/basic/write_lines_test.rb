require "test_helper"

# Tests Basic's WriteLines, which writes the lines of tokens as the
# representation.
class BasicWriteLinesTest < Minitest::Test
  def write(lines, track: "dart") = Inspector::Languages::Basic::WriteLines.(track, lines)

  def test_writes_tokens_with_single_spaces_and_keeps_line_breaks
    assert_equal "x = 1\ny", write([[0, ["x", "=", "1"]], [0, ["y"]]])
  end

  def test_quotes_a_token_with_whitespace_or_a_leading_double_quote
    assert_equal 'f "\"a b\"" "a b"', write([[0, ["f", '"a b"', "a b"]]])
  end

  def test_writes_indentation_depth_in_an_indentation_sensitive_track
    lines = [[0, ["a"]], [4, ["b"]], [8, ["c"]], [4, ["d"]], [0, ["e"]]]
    assert_equal "a\n  b\n    c\n  d\ne", write(lines, track: "python")
    assert_equal write(lines, track: "python"), write(lines.map { |indent, tokens| [indent / 2, tokens] }, track: "python")
  end

  def test_ignores_indentation_elsewhere
    assert_equal "a\nb", write([[0, ["a"]], [4, ["b"]]])
  end
end
