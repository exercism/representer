require_relative "toy_language"

# Checks the engine's renaming on small trees built by hand, without any
# language's stages.
class RenameUserDefinedNodesTest < Minitest::Test
  include ToyLanguage::Trees

  def test_renames_a_defined_name_where_it_is_defined_and_used
    tree = node(:program, assignment(leaf("x"), leaf("1", :integer)), node(:call, leaf("puts"), leaf("x")))
    assert_equal "(program\n  (assignment PLACEHOLDER_1 1)\n  (call puts PLACEHOLDER_1))", represent(tree)
  end

  def test_renames_a_use_before_its_definition
    tree = node(:program, node(:call, leaf("go")), node(:def, leaf("go")))
    assert_equal "(program\n  (call PLACEHOLDER_1)\n  (def PLACEHOLDER_1))", represent(tree)
  end

  def test_a_name_defined_twice_gets_one_placeholder
    tree = node(:program, assignment(leaf("x"), leaf("a")), assignment(leaf("x"), leaf("b")))
    assert_equal "(program\n  (assignment PLACEHOLDER_1 a)\n  (assignment PLACEHOLDER_1 b))", represent(tree)
  end

  def test_renames_a_symbol_with_a_defined_name
    tree = node(:program, node(:def, leaf("go")), node(:call, leaf("send"), leaf(":go", :simple_symbol)))
    assert_equal "(program\n  (def PLACEHOLDER_1)\n  (call send (simple_symbol :PLACEHOLDER_1)))", represent(tree)
  end

  def test_renames_a_library_name_that_the_solution_defines
    tree = node(:program, node(:def, leaf("sum")), node(:call, leaf("sum")))
    assert_equal "(program\n  (def PLACEHOLDER_1)\n  (call PLACEHOLDER_1))", represent(tree)
  end

  def test_keeps_a_call_to_a_method_that_the_solution_does_not_define
    tree = node(:program, node(:call, leaf("xs"), leaf("max")))
    assert_equal "(program\n  (call xs max))", represent(tree)
  end

  def test_numbers_placeholders_in_the_order_they_first_appear
    tree = node(:program, node(:def, leaf("b")), node(:def, leaf("a")), node(:call, leaf("b")))
    assert_equal "(program\n  (def PLACEHOLDER_1)\n  (def PLACEHOLDER_2)\n  (call PLACEHOLDER_1))", represent(tree)
    assert_equal({ "PLACEHOLDER_1" => "b", "PLACEHOLDER_2" => "a" }, @mapping)
  end

  private
  def represent(tree)
    Representer::Engine::RenameUserDefinedNodes.([tree], ToyLanguage::Representation::Spec)
    @mapping = Representer::Engine::NumberPlaceholders.(tree, ToyLanguage::Representation::Spec)
    Representer::Engine::Serialize.(tree)
  end
end
