require_relative "stage_helper"

# Checks ARM64 assembly's declarations of which nodes are names and which
# nodes define them (see arm64_assembly/representation/spec.rb), through the
# engine's renaming.
class Arm64AssemblyNamesTest < Minitest::Test
  include Arm64AssemblyStages

  def test_renames_labels_wherever_they_appear
    assert_equal %w[.loop main], renamed(".globl main\nmain: b .loop\n.loop: ret")
  end

  def test_renames_local_labels
    assert_equal %w[1], renamed("1: cbnz x0, 1b\nb 1f\n1: ret")
  end

  def test_renames_constants_and_register_aliases
    assert_equal %w[COUNT SIZE TOTAL], renamed(".equ SIZE, 8\nTOTAL = 2\nCOUNT .req x0\nmov COUNT, #SIZE + TOTAL")
  end

  def test_renames_macros_and_their_parameters
    assert_equal %w[push reg], renamed(".macro push reg\n  str \\reg, [sp, #-16]!\n.endm\npush x0")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_empty renamed("bl printf\nmov x0, x1")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Arm64Assembly::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Arm64Assembly::Representation::Spec.name?(node) }
    leaves
  end
end
