require_relative "toy_language"

class SameCodeTest < Minitest::Test
  include ToyLanguage::Trees

  SameCode = Inspector::Engine::SameCode

  def test_compares_types_texts_and_children
    assert SameCode.(node(:call, leaf("a")), node(:call, leaf("a")))
    refute SameCode.(node(:call, leaf("a")), node(:call, leaf("b")))
    refute SameCode.(node(:call, leaf("a")), node(:send, leaf("a")))
    refute SameCode.(node(:call, leaf("a")), node(:call, leaf("a"), leaf("b")))
  end

  def test_ignores_field_names
    assert SameCode.(leaf("a").tap { |name| name.field = "left" }, leaf("a"))
  end

  def test_compares_lists
    assert SameCode.([leaf("a"), leaf("b")], [leaf("a"), leaf("b")])
    refute SameCode.([leaf("a")], [leaf("a"), leaf("b")])
    refute SameCode.([], leaf("a"))
  end

  def test_a_list_of_one_node_is_that_node
    assert SameCode.([leaf("a")], leaf("a"))
    refute SameCode.([leaf("a")], leaf("b"))
  end
end
