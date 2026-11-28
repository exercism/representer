require_relative "stage_helper"

# Checks Prolog's declarations of which nodes are names and which nodes
# define them (see prolog/representation/spec.rb), through the engine's
# renaming.
class PrologNamesTest < Minitest::Test
  include PrologStages

  def test_renames_the_predicates_and_variables
    source = "leap(Year) :- divides(Year, 4).\ndivides(A, B) :- A mod B =:= 0.\n"
    assert_equal %w[A B Year divides leap], renamed(source)
  end

  def test_renames_facts_rules_with_no_arguments_and_grammar_rules
    source = "colour(red).\nmain :- colour(X), print(X).\ngreeting --> [hello], name.\n"
    assert_equal %w[X colour greeting main], renamed(source)
  end

  def test_renames_a_defined_predicate_wherever_its_name_appears
    source = "f(X) :- maplist(g, X).\ng(_).\n"
    assert_equal %w[X f g], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "f(L, M) :- lists:max_list(L, M), atom(red).\n"
    assert_equal %w[L M f], renamed(source)
  end

  def test_keeps_the_wildcard
    assert_equal %w[f], renamed("f(_).\n")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Prolog::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Prolog::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
