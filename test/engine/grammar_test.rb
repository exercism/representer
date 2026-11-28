require "test_helper"

class GrammarTest < Minitest::Test
  # A code pattern finds its code by the spans of the leaves, so the text
  # between the children of a node needs a span too.
  def test_gives_each_fragment_its_span_when_asked
    source = 'x = "a\\nb"'
    tree = Inspector::Engine::Grammar["python"].parse(source, gap_types: Set["string_content"], spans: true)
    fragments = []
    tree.each_descendant { |node| fragments << node if node.type == "fragment" }

    assert_equal(%w[a b], fragments.map(&:text))
    assert_equal(%w[a b], fragments.map { |fragment| source.byteslice(fragment.span) })
  end
end
