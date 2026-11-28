require "test_helper"

# Tests Basic's Tokenise, which splits a file into lines of tokens and drops
# the comments.
class BasicTokeniseTest < Minitest::Test
  def tokenise(source, track: "haskell") = Inspector::Languages::Basic::Tokenise.(track, source)

  def test_splits_lines_into_tokens_with_their_indentation
    assert_equal [[0, ["f", "x", "="]], [4, ["x", "+", "1"]]], tokenise("f x =\n    x + 1")
  end

  def test_counts_a_tab_as_eight_spaces
    assert_equal [[0, ["f", "="]], [8, ["1"]]], tokenise("f =\n\t1")
  end

  def test_drops_comments_and_lines_with_no_code
    assert_equal [[0, ["f", "=", "1"]]], tokenise("f = 1 -- one\n\n{- a\nblock -}\n")
  end

  def test_keeps_a_string_as_one_token_with_its_whitespace
    assert_equal [[0, ["f", "=", '"One for  you"']]], tokenise('f = "One for  you"')
  end

  def test_splits_at_whitespace_without_a_lexer
    assert_equal [[0, ["x", "=1", "#", "c"]]], tokenise("x =1 # c", track: "8th")
  end

  def test_reads_character_literals_that_look_like_comments
    assert_equal [[0, ["(", "insert", "?;", ")", "(", "foo", "1", ")"]]], tokenise("(insert ?;) (foo 1)", track: "emacs-lisp")
    assert_equal [[0, ["(", "display", '#\\;', ")"]]], tokenise('(display #\\;)', track: "scheme")
  end

  def test_reads_a_haxe_regex_with_slashes
    assert_equal [[0, ["r", "=", '~/\\/\\//', ";", "x"]]], tokenise('r = ~/\\/\\//; x', track: "haxe")
  end

  def test_drops_a_line_comment_after_a_preprocessor_line
    assert_equal tokenise("#define Y 2\n", track: "c"), tokenise("#define Y 2 // two\n", track: "c")
    refute_equal tokenise("#define Z \"a\"\n", track: "c"), tokenise("#define Z \"a//b\"\n", track: "c")
  end
end
