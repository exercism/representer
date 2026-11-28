require_relative "stage_helper"

# Checks MoonScript's declarations of which nodes are names and which nodes
# define them (see moonscript/representation/spec.rb), through the engine's
# renaming.
class MoonscriptNamesTest < Minitest::Test
  include MoonscriptStages

  def test_renames_variables_functions_and_parameters
    source = "local total\narea = (width, height = 1, ...) -> width * height\nif x = area 2 then total = x\n"
    assert_equal %w[area height total width x], renamed(source)
  end

  def test_renames_loop_variables_and_unpacked_names
    source = "for i = 1, 3 do print i\nfor k, v in pairs t do print k\n{a, :b, c: d} = t\n" \
             "y = [n for n = 1, 2]\n"
    assert_equal %w[a b d i k n v y], renamed(source)
  end

  def test_renames_classes_their_properties_and_the_fields_they_set
    source = "class Counter\n  @made: 0\n  new: (@start) =>\n    @count = @start\n  add: => @count += 1\n" \
             "M = {}\nM.go = -> Counter!\n{ :M, size: 2 }\n"
    assert_equal %w[Counter M add count go made size start], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "import fold from require 'moon'\nf = (t) -> table.concat fold(t), @other\n" \
             "class A\n  new: => 1\n  __tostring: => 'a'\n"
    assert_equal %w[A f t], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Moonscript::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Moonscript::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
