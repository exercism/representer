require_relative "stage_helper"

# Checks YAMLScript's declarations of which nodes are names and which nodes
# define them (see yamlscript/representation/spec.rb), through the engine's
# renaming.
class YAMLScriptNamesTest < Minitest::Test
  include YAMLScriptStages

  def test_renames_functions_parameters_and_variables
    source = "defn area(w *more):\n  h =: w.++\n  [a b] =: more\n  =>: area(h a b)\nlimit =: 64\n"
    assert_equal %w[a area b h limit more w], renamed(source)
  end

  def test_renames_the_names_that_bindings_define
    source = "defn f(xs):\n  loop i 0, [y *ys] xs:\n    recur: i.++ ys\n  =>: (fn [k v] k) (let [z 1] z)\n" \
             "defn g(qs):\n  filter _ qs:\n    fn(p): p\n"
    assert_equal %w[f g i k p qs v xs y ys z], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "defn f(xs):\n  str/join: xs.map(inc).filter(odd?)\n"
    assert_equal %w[f xs], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], YAMLScript::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if YAMLScript::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
