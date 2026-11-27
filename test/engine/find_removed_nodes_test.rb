require_relative "snippet_rules"

class FindRemovedNodesTest < Minitest::Test
  def find(source) = Representer::Engine::FindRemovedNodes.(SnippetRules::RubySnippet, SnippetRules.parse(source))

  def test_finds_every_comment
    source = "# One\nx = 1 # Two\n"
    assert_equal ["# One", "# Two"], find(source).map { |range| source.byteslice(range) }.sort
  end

  def test_finds_nothing_in_code_without_comments
    assert_empty find("x = 1\n")
  end
end
