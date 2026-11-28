require_relative "toy_language"

class DropImportsTest < Minitest::Test
  def test_drops_the_code_that_matches_an_import
    tree = Inspector::Engine::Grammar["ruby"].parse("require 'set'\nrequire name\nx = 1")
    Inspector::Engine::DropImports.(tree, ToyLanguage::Representation::Spec)
    assert_equal "(program\n  (call require\n    (argument_list name))\n  (assignment x = 1))",
      Inspector::Engine::Serialize.(tree)
  end
end
