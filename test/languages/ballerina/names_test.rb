require_relative "stage_helper"

# Checks Ballerina's declarations of which nodes are names and which nodes
# define them (see ballerina/representation.rb), through the engine's
# renaming.
class BallerinaNamesTest < Minitest::Test
  include BallerinaStages

  def test_renames_functions_and_types
    source = "function add(int x) returns int { return x; }\ntype P record {| int y; |};\nclass C { }\nenum E { RED }"
    assert_equal %w[C E P add x], renamed(source)
  end

  def test_renames_variables_parameters_and_lambda_parameters
    source = "function f(int a, int[] b) { int total = a; foreach int i in b { } var g = (m, n) => m + n; }"
    assert_equal %w[a b f g i m n total], renamed(source)
  end

  def test_keeps_record_fields_and_resource_names
    assert_equal ["P"], renamed("type P record {| int x; |};")
    assert_equal ["name"], renamed("service / on l { resource function get greeting(string name) { } }")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("function f(int n) returns int { return n; }\nfunction g() returns int { return f(1); }")
    assert(marks.select { |text, _| %w[f n].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a f], renamed("function f(string a) { io:println(a.length()); }")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[length main], renamed("function length() { }\npublic function main() { length(); }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Ballerina::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Ballerina::Representation::Spec.name?(node) }
    leaves
  end
end
