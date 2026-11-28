require_relative "toy_language"

class RepresentationTest < Minitest::Test
  Representation = ToyLanguage::Representation::Spec

  def test_belongs_to_the_spec_beside_it
    assert_equal ToyLanguage::Common::Spec, Representation.language
    assert_equal Representation, ToyLanguage::Common::Spec.representation
    assert_equal 2, ToyLanguage::Common::Spec.version
  end

  def test_says_which_leaves_are_names_and_their_text
    symbol = Rosetta::Engine::Node.leaf(:simple_symbol, ":count")
    assert Representation.name?(symbol)
    assert_equal "count", Representation.name_text(symbol)
    refute Representation.name?(Rosetta::Engine::Node.leaf(:integer, "1"))
  end

  def test_rejects_a_version_out_of_range
    assert_raises(ArgumentError) { Representation.version(1) }
  end
end
