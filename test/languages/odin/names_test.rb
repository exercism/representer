require_relative "stage_helper"

# Checks Odin's declarations of which nodes are names and which nodes
# define them (see odin/representation.rb), through the engine's renaming.
class OdinNamesTest < Minitest::Test
  include OdinStages

  def test_renames_the_package_and_top_level_declarations
    source = "package leap\nA :: 1\nB : int : 2\nc := 3\nd: int\nE :: struct { f, g: int }\n" \
             "H :: enum { I, J = 2 }\nK :: union { int, E }\nl :: proc() {}\nm :: proc{l}\n"
    assert_equal %w[A B E H I J K c d f g l leap m], renamed(source)
  end

  def test_renames_parameters_results_and_polymorphic_names
    source = "f :: proc(a, b: int, c := 1, $T: typeid, d: $U, e: [$N]int) -> (g: int, ok: bool) { return }\n" \
             "S :: struct($M: int) { h: [M]int }\n"
    assert_equal %w[M N S T U a b c d e f g h ok], renamed(source)
  end

  def test_renames_local_variables_loops_labels_and_type_switches
    source = "f :: proc(xs: []int, s: Shape) {\n\tx, y := 1, 2\n\tz: int\n" \
             "\touter: for v, i in xs { break outer }\n\tfor &w in xs { w = 0 }\n" \
             "\tswitch u in s { case int: z = u }\n\tif n, ok := g(); ok { z = n }\n}\n"
    assert_equal %w[f i n ok outer s u v w x xs y z], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("f :: proc(s: string) -> int { return len(strings.trim_space(s)) }\n")
    assert_equal %w[f], renamed("f :: proc() -> [dynamic]int { return make([dynamic]int, 0, context.allocator) }\n")
  end

  def test_keeps_the_blank_identifier
    assert_equal %w[f x xs], renamed("f :: proc(xs: []int) { for x, _ in xs { _ = x } }\n")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Odin::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Odin::Representation::Spec.name?(node) }
    leaves
  end
end
