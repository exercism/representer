require_relative "toy_language"

class PrepareFileTest < Minitest::Test
  # A language with comments and a GenerateAST stage of its own, before
  # which the engine drops the comments.
  module WithGenerateAST
    module Common
      class Spec < Inspector::Engine::Language
        grammar "ruby"
        comments_are :comment
      end

      class GenerateAST < Inspector::Engine::GenerateAST
        def call = tree
      end
    end

    module Representation
      class Spec < Inspector::Engine::Representation
        names_are :identifier
        imports 'require "{{...}}"'
      end
    end
  end

  def test_runs_only_the_stages_the_language_defines
    assert_equal "(program \"# hi\"\n  (assignment x = 1))", prepare(ToyLanguage::Common::Spec, "# hi\nx = 1")
    assert_equal "(program\n  (assignment x = 1))", prepare(WithGenerateAST::Common::Spec, "# hi\nx = 1")
  end

  def test_drops_the_imports
    assert_equal "(program\n  (assignment x = 1))", prepare(WithGenerateAST::Common::Spec, "require 'set'\nx = 1")
  end

  # A language that keeps the whole text of a string, and the text between
  # the children of an array.
  module WithText
    module Common
      class Spec < Inspector::Engine::Language
        grammar "ruby"
        text_nodes :string
        text_between_children :array
      end
    end

    module Representation
      class Spec < Inspector::Engine::Representation; end
    end
  end

  def test_keeps_the_text_the_language_asks_for
    assert_equal "(program\n  (assignment x = 'a'))", prepare(WithText::Common::Spec, "x = 'a'")
    assert_equal "(program\n  (assignment x =\n    (array [ 1 , \"   \" 2 ])))", prepare(WithText::Common::Spec, "x = [1,   2]")
  end

  def test_refuses_code_that_does_not_parse
    error = assert_raises(Inspector::CannotRepresent) { prepare(ToyLanguage::Common::Spec, "def x(") }
    assert_equal "parse_error", error.reason
  end

  def test_uses_the_tree_it_is_given_instead_of_parsing_the_source
    tree = Inspector::Engine::Grammar["ruby"].parse("y = 2")
    prepared = Inspector::Engine::PrepareFile.(WithGenerateAST::Common::Spec, "x = 1", tree:)
    assert_equal "(program\n  (assignment y = 2))", Inspector::Engine::Serialize.(prepared)
  end

  private
  def prepare(language, source) = Inspector::Engine::Serialize.(Inspector::Engine::PrepareFile.(language, source))
end
