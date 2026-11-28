require "test_helper"

class HaskellTest < InspectorTest
  track "haskell"

  def test_comments_and_layout_are_ignored
    assert_same_representation "module Leap (f) where\n\n-- | Says hello.\nf :: Int\n{- note -}\nf = 1 -- one\n",
      "module Leap (f) where\nf :: Int\nf =\n  1\n"
  end

  def test_imports_are_dropped
    assert_same_representation "module Leap (f) where\n\nimport Data.List (sort)\nimport qualified Data.Map as M\n\nf = sort\n",
      "module Leap (f) where\n\nf = sort\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "module Leap (isLeap) where\nisLeap year = divBy 4\n  where divBy n = year `mod` n == 0\n",
      "module Leap (isLeap) where\nisLeap y = d 4\n  where d k = y `mod` k == 0\n"
    assert_same_representation "module A (f) where\ndata Shape = Circle Double\nf :: Shape -> Double\nf (Circle r) = r\n",
      "module A (f) where\ndata Form = Round Double\nf :: Form -> Double\nf (Round x) = x\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "module A (f) where\nf = map succ\n", "module A (f) where\nf = map pred\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "module A (f) where\nf x = x + 1\n", "module A (f) where\nf x = x - 1\n"
    refute_same_representation "module A (f) where\nf x = x /= 1\n", "module A (f) where\nf x = x == 1\n"
    refute_same_representation "module A (f) where\nf a b = a - b\n", "module A (f) where\nf a b = b - a\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "module A (f) where\nf = (\n"
  end
end
