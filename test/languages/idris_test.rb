require "test_helper"

# Tests Rosetta as a whole on Idris solutions. The tests of each stage are in
# test/languages/idris/.
class IdrisTest < RosettaTest
  track "idris"

  def test_comments_layout_and_imports_go
    assert_same_representation "module Leap\n\nimport Data.List\n\n||| Says if a year is a leap year.\nexport\n" \
                               "isLeap : Int -> Bool\n-- The rule\nisLeap year = mod year 4 == 0 {- done -}\n",
                               "module Leap\nexport\nisLeap : Int -> Bool\nisLeap year =\n  mod year 4 == 0\n"
  end

  def test_names_the_solution_defines_are_renamed
    code = "module %s\ndata %s = %s Int\nexport\n%s : %s -> Int\n%s (%s %s) = %s %s\n  where %s %s = %s * 2\n"
    assert_same_representation format(code, "A", "Box", "MkBox", "f", "Box", "f", "MkBox", "n", "go", "n", "go", "x", "x"),
                               format(code, "B", "Item", "MkItem", "g", "Item", "g", "MkItem", "m", "h", "m", "h", "y", "y")
  end

  def test_names_from_the_library_keep_their_names
    refute_same_representation "f : List Int -> Int\nf xs = sum xs\n", "f : List Int -> Int\nf xs = product xs\n"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation "f : Int\nf = 1_000\ng : String\ng = \"a\\tb\"\n", "f : Int\nf = 1000\ng : String\ng = \"a\tb\"\n"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_idris_version
    assert_basic_representation "f : Int\nf = (\n"
  end
end
