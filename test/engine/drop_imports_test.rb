require_relative "toy_language"

class DropImportsTest < Minitest::Test
  def test_drops_the_code_that_matches_an_import
    tree = Representer::Engine::Grammar["ruby"].parse("require 'set'\nrequire name\nx = 1")
    Representer::Engine::DropImports.(tree, ToyLanguage::Representation)
    assert_equal "(program\n  (call require\n    (argument_list name))\n  (assignment x = 1))",
      Representer::Engine::Serialize.(tree, nil)
  end
end
