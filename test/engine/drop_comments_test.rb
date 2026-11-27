require_relative "toy_language"

class DropCommentsTest < Minitest::Test
  include ToyLanguage::Trees

  def test_drops_every_node_of_the_comment_types
    tree = node(:program, node(:comment, leaf("a")), node(:call, node(:doc_comment)), leaf("x"))
    assert_equal "(program\n  (call) x)", write(Representer::Engine::DropComments.(tree, %w[comment doc_comment]))
  end

  def test_leaves_the_tree_alone_with_no_comment_types
    tree = node(:program, node(:comment))
    assert_equal "(program\n  (comment))", write(Representer::Engine::DropComments.(tree, []))
  end

  private
  def write(tree) = Representer::Engine::Serialize.(tree)
end
