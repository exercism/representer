require_relative "toy_language"

class PrepareFileTest < Minitest::Test
  # A language with a GenerateAST stage of its own, which drops comments.
  module WithGenerateAST
    class Spec < Representer::Engine::Language
      grammar "ruby"
      names_are :identifier
      imports 'require "{{file}}"'
    end

    class GenerateAST < Representer::Engine::GenerateAST
      def call = drop(tree, "(comment)")
    end
  end

  def test_runs_only_the_stages_the_language_defines
    assert_equal "(program \"# hi\"\n  (assignment x = 1))", prepare(ToyLanguage::Spec, "# hi\nx = 1")
    assert_equal "(program\n  (assignment x = 1))", prepare(WithGenerateAST::Spec, "# hi\nx = 1")
  end

  def test_drops_the_imports
    assert_equal "(program\n  (assignment x = 1))", prepare(WithGenerateAST::Spec, "require 'set'\nx = 1")
  end

  # A language that keeps the whole text of a string, and the text between
  # the children of an array.
  module WithText
    class Spec < Representer::Engine::Language
      grammar "ruby"
      text_nodes :string
      text_between_children :array
    end
  end

  def test_keeps_the_text_the_language_asks_for
    assert_equal "(program\n  (assignment x = 'a'))", prepare(WithText::Spec, "x = 'a'")
    assert_equal "(program\n  (assignment x =\n    (array [ 1 , \"   \" 2 ])))", prepare(WithText::Spec, "x = [1,   2]")
  end

  def test_refuses_code_that_does_not_parse
    error = assert_raises(Representer::CannotRepresent) { prepare(ToyLanguage::Spec, "def x(") }
    assert_equal "parse_error", error.reason
  end

  def test_uses_the_tree_it_is_given_instead_of_parsing_the_source
    tree = Representer::Engine::Grammar["ruby"].parse("y = 2")
    prepared = Representer::Engine::PrepareFile.(WithGenerateAST::Spec, "x = 1", tree:)
    assert_equal "(program\n  (assignment y = 2))", Representer::Engine::Serialize.(prepared, nil)
  end

  private
  def prepare(language, source) = Representer::Engine::Serialize.(Representer::Engine::PrepareFile.(language, source), nil)
end
