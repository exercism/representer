require "test_helper"

class BlankCommentsTest < Minitest::Test
  COMMENT = /(?<!\S)!(?=\s|\z)[^\n]*/
  STRING = /"(?:\\.|[^"\\])*"/m

  def test_replaces_each_comment_with_spaces
    assert_equal "a #{' ' * 8}\nb", blank("a ! a note\nb")
  end

  def test_keeps_the_byte_size_of_each_comment
    assert_equal "a #{' ' * 4}\nb", blank("a ! é\nb")
  end

  def test_keeps_a_comment_marker_inside_a_string
    assert_equal "\"a ! b\" #{' ' * 3}", blank('"a ! b" ! c')
  end

  private
  def blank(source) = Inspector::Engine::BlankComments.(source, COMMENT, outside: STRING)
end
