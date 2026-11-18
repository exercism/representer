require "test_helper"

class PatternTest < Minitest::Test
  Node = Representer::Engine::Node

  # (pair key: a key: 1 key: b value: c), where a, b and c are identifiers.
  def pair
    children = [
      field(Node.leaf(:identifier, "a"), :key),
      field(Node.leaf(:number, "1"), :key),
      field(Node.leaf(:identifier, "b"), :key),
      field(Node.leaf(:identifier, "c"), :value)
    ]
    Node.new(:pair, children)
  end

  def test_field_pattern_matches_the_first_child_that_fits
    match = parse("(pair key: (number) @key)").match(pair)
    assert_equal "1", match["key"].text
  end

  def test_field_pattern_with_star_matches_every_child_that_fits
    match = parse("(pair key: (identifier)* @keys)").match(pair)
    assert_equal %w[a b], match["keys"].map(&:text)
  end

  def test_field_pattern_with_star_only_matches_children_with_that_field
    match = parse("(pair value: (identifier)* @values)").match(pair)
    assert_equal %w[c], match["values"].map(&:text)
  end

  def test_field_pattern_with_star_matches_when_no_child_fits
    match = parse("(pair key: (string)* @keys)").match(pair)
    assert_equal [], match["keys"]
  end

  def test_child_pattern_with_star_matches_every_child_that_fits
    match = parse("(pair (identifier)* @names)").match(pair)
    assert_equal %w[a b c], match["names"].map(&:text)
  end

  private
  def parse(source) = Representer::Engine::Pattern.parse(source)

  def field(node, name)
    node.field = name.to_s
    node
  end
end
