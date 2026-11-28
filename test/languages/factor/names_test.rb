require_relative "stage_helper"

# Checks Factor's declarations of which nodes are names and which nodes
# define them (see factor/representation.rb), through the engine's renaming.
class FactorNamesTest < Minitest::Test
  include FactorStages

  def test_renames_defined_words_and_the_names_in_their_stack_effects
    assert_equal %w[double g m n], renamed(": double ( n -- m ) 2 * ;\n: g ( -- m ) 3 double ;")
  end

  def test_renames_the_parameters_of_a_locals_word_and_the_names_bound_with_var_binding
    assert_equal %w[a b c d f], renamed(":: f ( a b -- c ) a b + :> d d ;")
  end

  def test_keeps_words_the_solution_does_not_define
    assert_equal %w[f n s], renamed(": f ( s -- n ) length 1 + ;")
  end

  def test_keeps_the_words_in_declarations
    assert_equal %w[f n], renamed("TUPLE: point x y ;\nCONSTANT: limit 10\n: f ( -- n ) limit ;")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Factor::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Factor::Representation::Spec.name?(node) }
    leaves
  end
end
