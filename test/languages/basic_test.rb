require "test_helper"

class BasicTest < RepresenterTest
  track "haskell"

  # Python has a class of its own, so the tests for indentation call Basic
  # directly.
  def basic(code, track: "haskell") = Representer::Languages::Basic.(track, { "solution" => code })

  def test_tracks_without_a_class_use_basic_and_its_version
    result = Representer::RepresentSolution.("haskell", { "Main.hs" => "main = print 1" }, {})
    assert_equal Representer::Languages::Basic, result.representer
    assert_nil result.reason
    assert_equal Representer::Languages::Basic::VERSION, result.version
    assert_empty result.mapping
  end

  def test_comments_and_spacing_are_ignored
    assert_same_representation "f x = x + 1 -- add one", "f  x=x+1\n\n{- a\nblock -}"
  end

  def test_whitespace_inside_strings_is_kept
    refute_same_representation 'f = "One for you"', 'f = "Oneforyou"'
    refute_same_representation 'f = "a  b"', 'f = "a b"'
  end

  def test_tokens_stay_apart
    refute_same_representation "f = a b", "f = ab"
  end

  def test_indentation_depth_is_kept_in_indentation_sensitive_languages
    loop_inside = "for x in xs:\n    print(x)\n    done(x)\n"
    loop_after = "for x in xs:\n    print(x)\ndone(x)\n"
    refute_equal basic(loop_inside, track: "python").representation, basic(loop_after, track: "python").representation
    assert_equal basic(loop_inside, track: "python").representation,
      basic("for x in xs:\n  print(x)\n  done(x)\n", track: "python").representation
  end

  def test_indentation_is_ignored_elsewhere
    assert_equal basic("if (x) {\n    y();\n}", track: "dart").representation,
      basic("if (x) {\ny();\n  }", track: "dart").representation
  end

  def test_line_breaks_are_kept
    refute_equal basic("return\nx", track: "dart").representation, basic("return x", track: "dart").representation
  end

  def test_tracks_without_a_lexer_split_at_whitespace
    assert_equal basic("x =  1", track: "8th").representation, basic("x = 1", track: "8th").representation
    refute_equal basic("x = 1", track: "8th").representation, basic("x =1", track: "8th").representation
  end

  def test_tokens_that_look_like_file_headers_are_quoted
    refute_equal Representer::RepresentSolution.("dart", { "a" => "x\n(file \"b\")" }, {}).representation,
      Representer::RepresentSolution.("dart", { "a" => "x", "b" => "" }, {}).representation
  end

  # Rouge reads these literals as the start of a comment or string, which
  # would drop the rest of the line.
  def test_character_literals_that_look_like_comments_keep_the_rest_of_the_line
    refute_equal basic("(insert ?;) (foo 1)", track: "emacs-lisp").representation,
      basic("(insert ?;) (foo 2)", track: "emacs-lisp").representation
    refute_equal basic("(insert ?\") (foo \"a\")", track: "emacs-lisp").representation,
      basic("(insert ?\") (foo \"b\")", track: "emacs-lisp").representation
    refute_equal basic('(display #\;) (foo 1)', track: "scheme").representation,
      basic('(display #\;) (foo 2)', track: "scheme").representation
    assert_equal basic('(insert ?\;) ; a comment', track: "emacs-lisp").representation,
      basic('(insert ?\;)', track: "emacs-lisp").representation
  end

  def test_a_haxe_regex_with_slashes_is_not_a_comment
    refute_equal basic('var r = ~/\/\//; var x = 1;', track: "haxe").representation,
      basic('var r = ~/\/\//; var x = 2;', track: "haxe").representation
    assert_equal basic("var r = ~/a/g; // c", track: "haxe").representation, basic("var r = ~/a/g;", track: "haxe").representation
  end
end
