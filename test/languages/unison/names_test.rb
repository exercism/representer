require_relative "stage_helper"

# Checks Unison's declarations of which nodes are names and which nodes
# define them (see unison/representation/spec.rb), through the engine's
# renaming.
class UnisonNamesTest < Minitest::Test
  include UnisonStages

  def test_renames_terms_and_their_parameters
    source = "leap.leap : Nat -> Boolean\nleap.leap year =\n  divisibleBy n = Nat.mod year n == 0\n  divisibleBy 4\n"
    assert_equal %w[divisibleBy leap n year], renamed(source)
  end

  def test_renames_the_parameters_of_lambdas_and_the_variables_in_patterns
    source = "f = cases\n  Some x, h +: t -> List.map (a b -> a + x) t\n  p@(y, _) | y > 0 -> !h\n" \
             "  { emit e -> k } -> handle k () with h\n"
    assert_equal %w[a b e f h k p t x y], renamed(source)
  end

  def test_renames_types_constructors_fields_abilities_and_type_variables
    source = "type Tree a = Leaf | Node (Tree a) a\ntype Point = { x : Nat }\n" \
             "ability Emit e where\n  emit : e -> ()\nf : [b] -> Optional b\nf = List.head\n"
    assert_equal %w[Emit Leaf Node Point Tree a b e emit f x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "use Nat mod\nf : Nat -> Optional Nat\nf n = Some (mod n 2)\nf2 = cases\n  None -> Less\n  Some _ -> Greater\n"
    assert_equal %w[f f2 n], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Unison::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Unison::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
