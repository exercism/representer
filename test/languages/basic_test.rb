require "test_helper"

class BasicTest < RepresenterTest
  track "haskell"

  def basic(code, track: "haskell") = Representer::RepresentSolution.(track, { "solution" => code }, {})

  def test_tracks_without_a_class_use_basic_and_its_version
    result = basic("main = print 1")
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
end
