require "test_helper"

# Factor has no old representer, so there are no upstream tests to port.
class FactorTest < RepresenterTest
  track "factor"

  def test_comments_are_dropped
    assert_same_representation "! note\n: f ( -- n ) 1 ; ! more\n", ": f ( -- n ) 1 ;"
    assert_same_representation "#! script\n: f ( -- n ) 1 ;", ": f ( -- n ) 1 ;"
  end

  def test_a_bang_in_a_string_is_not_a_comment
    refute_same_representation ": f ( -- s ) \"a ! b\" ;", ": f ( -- s ) \"a\" ;"
  end

  def test_formatting
    assert_same_representation ": f ( -- n )\n    1\n;", ":   f ( -- n ) 1 ;"
    assert_same_representation ": f ( -- n ) 1,000 ;", ": f ( -- n ) 1000 ;"
  end

  def test_defined_words_and_stack_effect_names_are_renamed
    assert_same_representation ": double ( n -- m ) 2 * ;\n: g ( -- m ) 3 double ;",
      ": twice ( x -- y ) 2 * ;\n: h ( -- y ) 3 twice ;"
    assert_same_representation ":: f ( a b -- c ) a b + ;", ":: g ( x y -- z ) x y + ;"
    assert_same_representation ":: f ( a -- c ) a :> b b ;", ":: f ( a -- c ) a :> d d ;"
  end

  def test_words_from_libraries_are_kept
    refute_same_representation ": f ( s -- n ) length ;", ": f ( s -- n ) reverse ;"
    refute_same_representation ": f ( n -- m ) 1 + ;", ": f ( n -- m ) 2 + ;"
  end

  def test_the_shape_of_the_stack_effect_matters
    refute_same_representation ": f ( a -- b ) ;", ": f ( a b -- ) ;"
  end
end
