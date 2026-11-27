require_relative "toy_language"

class RepresentWithStagesTest < Minitest::Test
  def test_renames_names_defined_in_any_file
    result = Representer::Engine::RepresentWithStages.(ToyLanguage::Spec, ["x = 1", "y = x"])
    assert_equal "(program\n  (assignment PLACEHOLDER_1 = 1)\n  (assignment PLACEHOLDER_2 = PLACEHOLDER_1))", result.representation
    assert_equal({ "PLACEHOLDER_1" => "x", "PLACEHOLDER_2" => "y" }, result.mapping)
  end

  def test_the_order_of_the_files_makes_no_difference
    one = Representer::Engine::RepresentWithStages.(ToyLanguage::Spec, ["x = 1", "y = 2"])
    other = Representer::Engine::RepresentWithStages.(ToyLanguage::Spec, ["b = 2", "a = 1"])
    assert_equal one.representation, other.representation
  end
end
