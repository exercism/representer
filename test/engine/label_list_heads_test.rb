require_relative "toy_language"

class LabelListHeadsTest < Minitest::Test
  include ToyLanguage::Trees

  def test_labels_the_first_item_of_each_list
    inner = node(:list, leaf("g"), leaf("y"))
    tree = node(:program, node(:list, leaf("f"), leaf("x"), inner))
    Rosetta::Engine::LabelListHeads.(tree, %w[list])

    assert_equal ["head", nil, nil], tree.children.first.children.map(&:field)
    assert_equal ["head", nil], inner.children.map(&:field)
  end

  def test_labels_only_the_types_given
    tree = node(:program, node(:vector, leaf("a"), leaf("b")))
    Rosetta::Engine::LabelListHeads.(tree, %w[list])

    assert_equal [nil, nil], tree.children.first.children.map(&:field)
  end
end
