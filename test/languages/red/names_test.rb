require_relative "stage_helper"

# Checks Red's declarations of which nodes are names and which nodes define
# them (see red/representation.rb), through the engine's renaming.
class RedNamesTest < Minitest::Test
  include RedStages

  def test_renames_set_words
    assert_equal %w[Title f total], renamed("Red [Title: \"x\"]\ntotal: 0\nf: does [total]")
  end

  def test_renames_parameters_and_locals
    assert_equal %w[a b f], renamed("f: func [a /local b] [b: a]")
  end

  def test_renames_loop_variables
    assert_equal %w[c i], renamed("foreach c \"ab\" [print c]\nrepeat i 3 [print i]")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("p: make object! [x: 1]\nprint p/x\nprint :p")
    assert(marks.select { |text, _| %w[p x].include?(text) }.all?(&:last))
  end

  def test_keeps_words_the_solution_does_not_define
    assert_equal ["s"], renamed("s: \"ab\"\nprint reverse uppercase s")
  end

  def test_renames_library_words_the_solution_defines
    assert_equal %w[main reverse], renamed("reverse: does [1]\nmain: does [reverse]")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Red::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Red::Representation::Spec.name?(node) }
    leaves
  end
end
