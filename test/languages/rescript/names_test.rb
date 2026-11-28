require_relative "stage_helper"

# Checks ReScript's declarations of which nodes are names and which nodes
# define them (see rescript/representation.rb), through the engine's
# renaming.
class RescriptNamesTest < Minitest::Test
  include RescriptStages

  def test_renames_functions_and_their_parameters
    source = "let rec area = (width, ~height, ~depth as d=1, (a, b), type t) => width\nlet limit = 10"
    assert_equal %w[a area b d depth height limit t width], renamed(source)
  end

  def test_renames_the_variables_in_patterns_and_loops
    source = "let f = x => switch x {\n| Some(y) => y\n| list{h, ...t} => h\n| [a, b] => a\n| {k, v: w} => k\n" \
             "| (Ok(_) | Error(_)) as e => e\n}\nfor i in 0 to 9 { () }"
    assert_equal %w[a b e f h i k t w x y], renamed(source)
  end

  def test_renames_types_constructors_fields_and_type_variables
    source = "type rec tree<'a> = Leaf | Node({value: 'a, left: tree<'a>})\ntype colour = [#red | #blue]\nexception Invalid(string)"
    assert_equal %w[#blue #red 'a Invalid Leaf Node colour left tree value], renamed(source)
  end

  def test_renames_modules_functor_parameters_and_externals
    source = "module Counter = { let count = 0 }\nmodule Make = (X: S) => { let y = X.y }\n" \
             "@val external alert: string => unit = \"alert\""
    assert_equal %w[Counter Make X alert count y], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "let f = xs => xs->Array.map(x => Int.toString(x))->Array.join(\"\")\nlet g = _ => Some(#red)"
    assert_equal %w[f g x xs], renamed(source)
  end

  def test_a_default_value_defines_nothing
    assert_equal %w[f size width], renamed("let f = (~width=size) => width\nlet size = 1")
    assert_equal %w[f width], renamed("let f = (~width=size) => width")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Rescript::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Rescript::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
