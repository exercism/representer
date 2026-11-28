require_relative "toy_language"

class SortChildrenTest < Minitest::Test
  include ToyLanguage::Trees

  def test_sorts_the_children_of_the_given_types_only
    tree = node(:program, node(:body, leaf("b"), leaf("a")), node(:list, leaf("b"), leaf("a")))
    assert_equal "(program\n  (body a b)\n  (list b a))", sort(tree, :body)
  end

  def test_sorts_with_renamed_names_left_blank
    tree = node(:body, node(:def, renamed(leaf("a")), leaf("2")), node(:def, renamed(leaf("b")), leaf("1")))
    assert_equal "(body\n  (def b 1)\n  (def a 2))", sort(tree, :body)
  end

  def test_keeps_the_order_of_children_with_the_same_code
    tree = node(:body, node(:def, renamed(leaf("b"))), node(:def, renamed(leaf("a"))))
    assert_equal "(body\n  (def b)\n  (def a))", sort(tree, :body)
  end

  def test_sorts_inner_nodes_before_outer_ones
    first = node(:body, node(:def, leaf("x"), node(:body, leaf("c"), leaf("a"))), node(:def, leaf("x"), node(:body, leaf("b"))))
    second = node(:body, node(:def, leaf("x"), node(:body, leaf("a"), leaf("c"))), node(:def, leaf("x"), node(:body, leaf("b"))))
    assert_equal sort(second, :body), sort(first, :body)
  end

  private
  def renamed(leaf) = leaf.tap { leaf.renamed = true }
  def sort(tree, *types) = Inspector::Engine::Serialize.(Inspector::Engine::SortChildren.(tree, types))
end
