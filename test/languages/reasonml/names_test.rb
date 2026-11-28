require_relative "stage_helper"

# Checks ReasonML's declarations of which nodes are names and which nodes
# define them (see reasonml/representation/spec.rb), through the engine's
# renaming.
class ReasonmlNamesTest < Minitest::Test
  include ReasonmlStages

  def test_renames_functions_values_operators_and_parameters
    source = "let limit = 4;\nlet rec isLeap = year => year mod limit == 0;\nlet (>>) = (f, g, x) => g(f(x));"
    assert_equal [">>", "f", "g", "isLeap", "limit", "x", "year"], renamed(source)
  end

  def test_renames_the_variables_in_patterns_and_loops
    source = "let (a, b) = pair;\nlet f = fun\n  | Some([x, ...xs]) when x > 0 => xs\n  | Some([] as e) => e\n  | None => [];\n" \
             "let g = ({width, height: h}) => for (i in 0 to h) { ignore((width, i)) };"
    assert_equal %w[a b e f g h i width x xs], renamed(source)
  end

  def test_renames_labels
    source = "let area = (~width, ~height=1, ~depth as d, ()) => width * height * d;\nlet x = area(~width=2, ~depth=3, ());"
    assert_equal %w[area d depth height width x], renamed(source)
  end

  def test_renames_types_constructors_fields_and_type_variables
    source = "type tree('a) = Leaf | Node(tree('a), 'a, tree('a));\ntype point = {x: int, mutable y: int};\n" \
             "exception Oops(string);\nlet first = (xs: list('b)) => List.hd(xs);"
    assert_equal ["'a", "'b", "Leaf", "Node", "Oops", "first", "point", "tree", "x", "xs", "y"], renamed(source)
  end

  def test_renames_modules_and_module_types
    source = "module type Shape = { let area: int => int; };\nmodule Make = (S: Shape) => { let v = S.area(1); };"
    assert_equal %w[Make S Shape area v], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "open Belt;\nlet f = (s: string) => [s] |> List.map(String.uppercase_ascii) |> List.rev;"
    assert_equal %w[f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Reasonml::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Reasonml::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
