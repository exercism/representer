require_relative "stage_helper"

# Checks jq's declarations of which nodes are names and which nodes define
# them (see jq/representation.rb), through the engine's renaming.
class JqNamesTest < Minitest::Test
  include JqStages

  def test_renames_functions_and_their_parameters
    source = <<~JQ
      def add_all(f; $start):
        def step: . + f;
        reduce .[] as $x ($start; step);
      add_all(1; 0)
    JQ
    assert_equal %w[$start $x add_all f step], renamed(source)
  end

  def test_renames_the_variables_in_patterns_and_labels
    source = <<~JQ
      . as [$first, {name: $n, $age}] ?// $whole
      | label $out
      | foreach .[] as $item (0; . + 1; if . > 3 then ., break $out else . end)
    JQ
    assert_equal %w[$age $first $item $n $out $whole], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = <<~JQ
      include "lib";
      .items | map(select(.price > 1) | .name) | length, $ENV.HOME, env
    JQ
    assert_equal [], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Jq::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Jq::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
