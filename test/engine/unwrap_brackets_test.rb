require_relative "toy_language"

class UnwrapBracketsTest < Minitest::Test
  include ToyLanguage::Trees

  def test_unwraps_brackets_with_one_named_child
    tree = node(:program, node(:parens, node(:parens, leaf("a"))), node(:parens, leaf("b"), leaf("c")))
    assert_equal "(program a\n  (parens b c))", write(Representer::Engine::UnwrapBrackets.(tree, %w[parens]))
  end

  def test_unwraps_only_the_types_given
    tree = node(:program, node(:block, leaf("a")))
    assert_equal "(program\n  (block a))", write(Representer::Engine::UnwrapBrackets.(tree, %w[parens]))
  end

  private
  def write(tree) = Representer::Engine::Serialize.(tree)
end
