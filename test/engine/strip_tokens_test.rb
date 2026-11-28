require_relative "toy_language"

class StripTokensTest < Minitest::Test
  include ToyLanguage::Trees

  Node = Inspector::Engine::Node

  def test_strips_tokens_everywhere_apart_from_the_kept_ones
    tree = node(:program, node(:call, Node.token("("), Node.token(";")), node(:for, Node.token(";")))
    stripped = Inspector::Engine::StripTokens.(tree, %w[( ;], kept_in: { "for" => %w[;] })
    assert_equal "(program\n  (call)\n  (for ;))", write(stripped)
  end

  def test_strips_tokens_only_from_the_types_given
    tree = node(:program, node(:superclass, Node.token("<")), node(:binary, Node.token("<")))
    stripped = Inspector::Engine::StripTokens.(tree, [], only_in: { "superclass" => %w[<] })
    assert_equal "(program\n  (superclass)\n  (binary <))", write(stripped)
  end

  private
  def write(tree) = Inspector::Engine::Serialize.(tree)
end
