require "test_helper"

class PharoSmalltalkTest < RosettaTest
  track "pharo-smalltalk"

  def test_comments_and_layout_are_ignored
    assert_same_representation "\"Says hello.\"\nFoo >> hello [\n\t\"the greeting\"\n\t^ 'hi'\n]\n",
                               "Foo >> hello [ ^ 'hi' ]"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation <<~FIRST, <<~SECOND
      Class { #name : #Leap, #superclass : #Object, #instVars : [ 'year' ] }
      Leap >> isLeap: aYear [ | r | r := aYear \\\\ 4. ^ r = 0 ]
    FIRST
      Class { #name : #Calendar, #superclass : #Object, #instVars : [ 'y' ] }
      Calendar >> leap: n [ | x | x := n \\\\ 4. ^ x = 0 ]
    SECOND
  end

  def test_names_from_outside_are_kept
    refute_same_representation "Foo >> f: s [ ^ s asUppercase ]", "Foo >> f: s [ ^ s asLowercase ]"
    refute_same_representation "Foo >> f [ ^ #ok ]", "Foo >> f [ ^ #error ]"
    refute_same_representation "Class { #name : #Foo, #superclass : #Object }",
                               "Class { #name : #Foo, #superclass : #Dictionary }"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "Foo >> f: x [ ^ x + 1 ]", "Foo >> f: x [ ^ x - 1 ]"
    refute_same_representation "Foo >> f: x [ ^ x = 1 ]", "Foo >> f: x [ ^ x == 1 ]"
    refute_same_representation "Foo >> f: x [ ^ x ]", "Foo class >> f: x [ ^ x ]"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "Foo >> f [ ^ 1"
  end
end
