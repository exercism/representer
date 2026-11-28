require_relative "stage_helper"

# Checks Futhark's declarations of which nodes are names and which nodes
# define them (see futhark/representation/spec.rb), through the engine's
# renaming.
class FutharkNamesTest < Minitest::Test
  include FutharkStages

  def test_renames_functions_and_their_parameters
    source = "def area [n] (w: [n]i32) h = let g x = x * h in map g w\nlet total = area\n"
    assert_equal %w[area g h n total w x], renamed(source)
  end

  def test_renames_the_variables_in_patterns_and_loops
    source = "def f xs = let (a, b: i32) = (1, 2) let {c = d, e} = r\n" \
             "in loop acc = a for i < b do loop s = acc for y in xs do " \
             "match y case #some z -> z case w -> s + w + (\\v -> v) d + e\n"
    assert_equal %w[a acc b c d e f i s v w xs y z], renamed(source)
  end

  def test_renames_types_constructors_fields_and_modules
    source = "type color 'a = #red | #green a\ntype point = {x: i32}\nmodule m (p: integral) = { def k = 1 }\n" \
             "module type s = { val q : i32 }\ndef f (c: ?[n].[n]i32) = {x = 1}\n" \
             "def (+++) a b = a + b\n"
    assert_equal %w[#green #red +++ a b c color f k m n p point q s x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "import \"lib/sorts\"\ndef f (xs: []i32): i32 = i32.sum (map i32.abs xs) + reduce (+) 0 xs\n" \
             "module m (p: integral) = { def k = 1 }\n"
    assert_equal %w[f k m p xs], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Futhark::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Futhark::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
