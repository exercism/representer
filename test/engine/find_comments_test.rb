require_relative "snippet_rules"

class FindCommentsTest < Minitest::Test
  def comments(source, track: "none")
    Representer::Engine::FindComments.(SnippetRules::LinesSnippet, track, source).map { |range| source.byteslice(range) }
  end

  def test_uses_the_tracks_lexer
    assert_equal ["// One", "/* Two */"], comments("// One\nint x; /* Two */\n#include <a.h>\n", track: "c")
  end

  def test_finds_line_and_block_comments_by_their_markers
    assert_equal ["// One\n", "/*\n", "  Two\n", "*/\n"], comments("// One\n/*\n  Two\n*/\nx = 1\n")
  end

  def test_finds_a_comment_after_code
    assert_equal ["// Two\n"], comments("x = 1 // Two\n")
  end

  def test_keeps_a_marker_that_might_be_in_a_string
    assert_empty comments("x = \"a // b\n")
  end
end
