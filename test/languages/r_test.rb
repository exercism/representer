require "test_helper"

# Tests Rosetta as a whole on R solutions. The tests of each stage are in
# test/languages/r/.
class RTest < RosettaTest
  track "r"

  def wrap(body) = "f <- function(a, b) {\n#{body}\n}\n"

  def test_comments_and_formatting
    assert_same_representation "# c\nf <- function() {\n  1 # x\n}\n", "f <- function() { 1 }"
    assert_same_representation wrap("c <- (a + b)\nc"), wrap("c <- a + b; c")
    refute_same_representation wrap("(a + b) * a"), wrap("a + b * a")
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation wrap("total <- a + b\ntotal"), wrap("sum <- a + b\nsum")
    assert_same_representation "area <- function(w, h) w * h", "size <- function(x, y) x * y"
    refute_same_representation wrap("total <- a + b\ntotal"), wrap("total <- a + a\ntotal")
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation wrap("toupper(a)"), wrap("tolower(a)")
  end

  def test_imports_are_dropped
    assert_same_representation "library(stringr)\nx <- 1", "x <- 1"
    assert_same_representation "require('dplyr')\nx <- 1", "x <- 1"
    assert_same_representation "if (!require(dplyr)) install.packages('dplyr')\nx <- 1", "x <- 1"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation wrap("a + 1e3"), wrap("a + 1000")
    assert_same_representation wrap("'you'"), wrap('"you"')
    refute_same_representation wrap("'you'"), wrap("'me'")
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f <- function( "
  end
end
