require_relative "toy_language"

class NumberPlaceholdersTest < Minitest::Test
  include ToyLanguage::Trees

  def test_numbers_the_renamed_leaves_in_order_and_returns_the_mapping
    tree = node(:program, renamed(leaf("b")), leaf("kept"), renamed(leaf("a")), renamed(leaf("b")))
    mapping = Rosetta::Engine::NumberPlaceholders.(tree, ToyLanguage::Representation::Spec)
    assert_equal({ "PLACEHOLDER_1" => "b", "PLACEHOLDER_2" => "a" }, mapping)
    assert_equal "(program PLACEHOLDER_1 kept PLACEHOLDER_2 PLACEHOLDER_1)", Rosetta::Engine::Serialize.(tree)
  end

  def test_writes_the_type_of_any_name_but_the_first_type
    tree = node(:program, renamed(leaf("X", :constant)), renamed(leaf(":go", :simple_symbol)))
    mapping = Rosetta::Engine::NumberPlaceholders.(tree, ToyLanguage::Representation::Spec)
    assert_equal({ "PLACEHOLDER_1" => "X", "PLACEHOLDER_2" => "go" }, mapping)
    assert_equal "(program (constant PLACEHOLDER_1) (simple_symbol :PLACEHOLDER_2))", Rosetta::Engine::Serialize.(tree)
  end

  private
  def renamed(leaf) = leaf.tap { leaf.renamed = true }
end
