require "test_helper"

# Tests Rosetta as a whole on Factor solutions. test/languages/factor/ tests each
# stage and the names.
class FactorTest < RosettaTest
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

  def test_the_shape_of_the_stack_effect_matters
    refute_same_representation ": f ( a -- b ) ;", ": f ( a b -- ) ;"
  end

  def test_using_and_use_are_dropped
    assert_same_representation "USING: kernel math\n  sequences ;\nUSE: io\nIN: a\n: f ( x -- y ) 1 + ;", "IN: a\n: f ( x -- y ) 1 + ;"
  end

  def test_the_vocabulary_name_matters
    refute_same_representation "IN: a\n: f ( x -- y ) 1 + ;", "IN: b\n: f ( x -- y ) 1 + ;"
  end
end
