require "test_helper"

# Checks that the engine stops a solution with no representation, and never
# raises, when a language's rules hit one of its limits.
class RepresentTest < Minitest::Test
  # A rule that returns the node it matched, unchanged, keeps matching it.
  class SameNode < Representer::Language
    version 2
    grammar "ruby"
    extensions ".rb"
    names :identifier
    rewrite("(integer) @number", &:node)
  end

  # Two rules that undo each other keep replacing the node.
  class Oscillating < Representer::Language
    version 2
    grammar "ruby"
    extensions ".rb"
    names :identifier
    rewrite("(integer) @number") { |match| leaf(:float, match.node.text) }
    rewrite("(float) @number") { |match| leaf(:integer, match.node.text) }
  end

  def test_a_rule_that_keeps_matching_its_own_output
    [SameNode, Oscillating].each do |language|
      error = assert_raises(Representer::CannotRepresent) { language.({ "a.rb" => "x = 1" }, {}) }
      assert_equal "too_complex", error.reason
    end
  end

  def test_solution_files_in_other_formats_are_ignored
    result = SameNode.({ "a.rb" => "x", "README.md" => "1" }, {})
    refute_includes result.representation, "README"
  end

  def test_a_solution_with_no_source_files
    error = assert_raises(Representer::CannotRepresent) { SameNode.({ "README.md" => "x" }, {}) }
    assert_equal "no_source_files", error.reason
  end
end
