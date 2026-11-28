require_relative "stage_helper"

# Checks PureScript's declarations of which nodes are names and which nodes
# define them (see purescript/representation.rb), through the engine's
# renaming.
class PureScriptNamesTest < Minitest::Test
  include PureScriptStages

  def test_renames_the_module_functions_values_and_parameters
    source = "module Leap (isLeap) where\n\nlimit = 4\nisLeap :: Int -> Boolean\nisLeap year = year `mod` limit == 0\n"
    assert_equal %w[Leap isLeap limit year], renamed(source)
  end

  def test_renames_the_variables_in_patterns
    source = in_module("f [a, b] { x: c } = case a of\n  Just y | Just z <- g y -> \\p -> z\n  _ -> b\n" \
                       "  where\n    h = do\n      line <- getLine\n      let n = 1\n      pure n")
    assert_equal %w[Leap a b c f h line n p y z], renamed(source)
  end

  def test_renames_operators_the_solution_defines
    source = in_module("infixl 6 add as +++\nf a b = a +++ b")
    assert_equal %w[+++ Leap a b f], renamed(source)
  end

  def test_renames_types_constructors_labels_classes_instances_and_type_variables
    source = in_module("data Shape a = Circle a | Rect { width :: a }\nnewtype Name = Name String\n" \
                       "type Point = { x :: Int }\nclass Sized t where\n  size :: t -> Int\n" \
                       "instance sizedShape :: Sized (Shape a) where\n  size _ = 1\n" \
                       "derive instance eqName :: Eq Name\nf :: forall k. Ord k => k -> k\nf k = k")
    assert_equal %w[Circle Leap Name Point Rect Shape Sized a eqName f k size sizedShape t width x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = in_module("import Data.Map as M\nf :: Array Int -> M.Map Int Int\nf xs = M.fromFoldable (map (\\x -> Tuple x x) xs)")
    assert_equal %w[Leap f x xs], renamed(source)
  end

  def test_keeps_the_names_of_instance_methods_and_booleans
    source = in_module("instance showShape :: Show Shape where\n  show _ = \"shape\"\n" \
                       "f = case g of\n  Just true -> show 1\n  _ -> \"\"")
    assert_equal %w[Leap f showShape], renamed(source)
  end

  def test_keeps_the_constructors_in_patterns
    source = in_module("f (Just x) = x\nf Nothing = 0")
    assert_equal %w[Leap f x], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], PureScript::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if PureScript::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
