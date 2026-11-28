require_relative "stage_helper"

# Checks Euphoria's declarations of which nodes are names and which nodes
# define them (see euphoria/representation/spec.rb), through the engine's
# renaming.
class EuphoriaNamesTest < Minitest::Test
  include EuphoriaStages

  def test_renames_routines_parameters_and_variables
    source = "public function area(integer width, integer height = 1)\n" \
             "  integer total = width * height\n  return total\nend function\n" \
             "procedure greet()\nend procedure\n"
    assert_equal %w[area greet height total width], renamed(source)
  end

  def test_renames_types_constants_enums_loops_and_the_namespace
    source = "namespace shapes\nconstant LIMIT = 10\nenum RED, GREEN\n" \
             "type positive(integer x)\n  return x > 0\nend type\n" \
             "for i = 1 to LIMIT do\n  ? i\nend for\n"
    assert_equal %w[GREEN LIMIT RED i positive shapes x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "include std/math.e as m\nfunction f(sequence s)\n  return m:sum(s) + length(s)\nend function\n"
    assert_equal %w[f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    leaves = []
    prepare_and_rename(source).each_descendant do |node|
      leaves << node.text if Euphoria::Representation::Spec.name?(node) && node.renamed
    end
    leaves.uniq.sort
  end

  def prepare_and_rename(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Euphoria::Representation::Spec)
    tree
  end
end
