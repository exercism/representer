require_relative "stage_helper"

# Checks x86-64 assembly's declarations of which nodes are names and which
# nodes define them (see x8664_assembly/representation/spec.rb), through the
# engine's renaming.
class X8664AssemblyNamesTest < Minitest::Test
  include X8664AssemblyStages

  def test_renames_labels_wherever_they_appear
    assert_equal [".loop", "main"], renamed("global main\nmain: jmp .loop\n.loop: ret")
  end

  def test_renames_macro_labels
    assert_equal ["%%skip", "check"], renamed("%macro check 0\n  jz %%skip\n%%skip:\n%endmacro\ncheck")
  end

  def test_renames_data_and_constants
    assert_equal %w[SIZE len msg], renamed("msg db 'hi'\nlen equ $ - msg\nSIZE: equ 8\nmov rax, SIZE")
  end

  def test_renames_defines_and_their_parameters
    assert_equal %w[COUNT a b max step],
                 renamed("%define COUNT 4\n%define max(a, b) a\n%assign step 1\nmov rax, max(COUNT, step)")
  end

  def test_renames_strucs_and_their_fields
    assert_equal [".x", "point"], renamed("struc point\n  .x resq 1\nendstruc")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_empty renamed("extern printf\ncall printf\nmov rax, rbx")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], X8664Assembly::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if X8664Assembly::Representation::Spec.name?(node) }
    leaves
  end
end
