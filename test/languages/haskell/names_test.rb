require_relative "stage_helper"

# Checks Haskell's declarations of which nodes are names and which nodes
# define them (see haskell/representation.rb), through the engine's
# renaming.
class HaskellNamesTest < Minitest::Test
  include HaskellStages

  def test_renames_the_module_functions_values_and_parameters
    source = "module Leap (isLeap) where\n\nlimit = 4\nisLeap :: Int -> Bool\nisLeap year = year `mod` limit == 0\n"
    assert_equal %w[Leap isLeap limit year], renamed(source)
  end

  def test_renames_the_variables_in_patterns
    source = in_module("f (x:xs) all@(a, b) Just {} = case x of\n  Just y | Just z <- g y -> \\p -> [k | k <- z]\n  _ -> xs\n" \
                       "  where\n    (c, d) = (a, b)\n    h = do\n      line <- getLine\n      let n = 1\n      pure n")
    assert_equal %w[Leap a all b c d f h k line n p x xs y z], renamed(source)
  end

  def test_renames_operators_the_solution_defines
    source = in_module("infixl 1 |>\n(|>) :: a -> (a -> b) -> b\nx |> f = f x\n(+++) = (++)\na `plus` b = a + b")
    assert_equal %w[+++ Leap a b f plus x |>], renamed(source)
  end

  def test_renames_types_constructors_fields_classes_and_type_variables
    source = in_module("data Shape a = Circle a | Rect { width :: a }\nnewtype Name = Name String\n" \
                       "type Grid = [[Int]]\nclass Sized t where\n  size :: t -> Int\n" \
                       "data Complex = Double :+ Double\nf :: Ord k => k -> k\nf k = k")
    assert_equal %w[:+ Circle Complex Grid Leap Name Rect Shape Sized a f k size t width], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = in_module("import qualified Data.Map as M\nf :: [Int] -> M.Map Int Int\nf xs = M.fromList (zip xs xs)")
    assert_equal %w[Leap f xs], renamed(source)
  end

  def test_keeps_the_function_of_a_view_pattern
    source = "{-# LANGUAGE ViewPatterns #-}\n#{in_module('f (reverse -> x) = x')}"
    assert_equal %w[Leap f x], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Haskell::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Haskell::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
