require_relative "stage_helper"

# Checks CFML's declarations of which nodes are names and which nodes define
# them (see cfml/representation.rb), through the engine's renaming.
class CFMLNamesTest < Minitest::Test
  include CFMLStages

  def test_renames_functions_parameters_and_variables
    source = "component { function leapYear(year, n = 4) { var total = 0; count = 1; return year % n; } }"
    assert_equal %w[count leapyear n total year], renamed(source)
  end

  def test_renames_the_variables_set_on_scopes
    source = "component { function f() { local.a = 1; variables.b = 2; this.c = 3; return arguments.d; } }"
    assert_equal %w[a b c f], renamed(source)
  end

  def test_renames_the_variables_of_loops_closures_and_catch
    source = "component { function f(xs) { for (var x in xs) {} try {} catch (any e) {} " \
             "return xs.map((v) => v) + xs.map(function(w) { return w; }); } }"
    assert_equal %w[e f v w x xs], renamed(source)
  end

  def test_keeps_named_arguments_attributes_and_types
    source = "component { string function f(numeric n) output=false { return listToArray(list = n); } }"
    assert_equal %w[f n], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "component { function f(s) { return ucase(s) & arguments.s.len(); } }"
    assert_equal %w[f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], CFML::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if CFML::Representation.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
