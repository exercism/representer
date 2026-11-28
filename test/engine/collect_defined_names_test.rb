require_relative "toy_language"

class CollectDefinedNamesTest < Minitest::Test
  include ToyLanguage::Trees

  def test_collects_every_name_defined_in_every_tree
    first = node(:program, node(:def, leaf("go"), node(:body, leaf("x"))))
    second = node(:program, assignment(leaf("y"), leaf("z")))
    assert_equal Set["go", "y"], Rosetta::Engine::CollectDefinedNames.([first, second], ToyLanguage::Representation::Spec)
  end

  def test_a_field_limits_the_definition_to_that_child
    tree = node(:program, assignment(leaf("y"), leaf("z")))
    assert_equal Set["y"], Rosetta::Engine::CollectDefinedNames.([tree], ToyLanguage::Representation::Spec)
  end

  def test_a_field_defines_every_child_in_it
    left = [leaf("a"), leaf("b")].each { |name| name.field = "left" }
    tree = node(:program, node(:assignment, *left, leaf("c")))
    assert_equal Set["a", "b"], Rosetta::Engine::CollectDefinedNames.([tree], ToyLanguage::Representation::Spec)
  end

  def test_only_children_that_are_names_count
    tree = node(:program, node(:def, node(:call, leaf("inner")), leaf("go")))
    assert_equal Set["go"], Rosetta::Engine::CollectDefinedNames.([tree], ToyLanguage::Representation::Spec)
  end
end
