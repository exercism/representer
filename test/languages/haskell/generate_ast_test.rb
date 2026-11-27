require_relative "stage_helper"

# Tests Haskell's GenerateAST stage. Each assert_same pair has the same
# meaning in Haskell, and each refute_same pair has different meanings.
class HaskellGenerateASTTest < Minitest::Test
  include HaskellStages

  def test_layout_braces_and_semicolons_make_no_difference
    assert_same in_module("f x = do\n  print x\n  print x"), in_module("f x = do { print x; print x }")
    assert_same in_module("f x\n  | x > 0 = 1\n  | otherwise = 0"), in_module("f x | x > 0 = 1 | otherwise = 0")
  end

  def test_unicode_syntax_is_the_same_as_ascii
    assert_same in_module("f ∷ Int → Int"), in_module("f :: Int -> Int")
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_module("f x = g (h x)"), in_module("f x = g ((h x))")
    assert_same in_module("f x = (g x) 1"), in_module("f x = g x 1")
    assert_same in_module("f :: Int -> (Int -> Int)"), in_module("f :: Int -> Int -> Int")
    refute_same in_module("f x = g (h x)"), in_module("f x = g h x")
  end

  def test_brackets_inside_an_operator_expression_stay
    refute_same in_module("f a b c = a - (b - c)"), in_module("f a b c = a - b - c")
    refute_same in_module("f a b c = (a + b) * c"), in_module("f a b c = a + b * c")
    refute_same in_module("f x = (-x) ^ 2"), in_module("f x = -x ^ 2")
  end

  def test_a_tight_dot_is_composition
    assert_same in_module("f = filter (not.isSpace)"), in_module("f = filter (not . isSpace)")
    refute_same in_module("f = g.h x"), in_module("f = (g . h) x")
  end

  def test_a_dot_is_a_field_with_overloaded_record_dot
    refute_same "{-# LANGUAGE OverloadedRecordDot #-}\n#{in_module('f p = p.x')}",
                "{-# LANGUAGE OverloadedRecordDot #-}\n#{in_module('f p = p . x')}"
  end

  def test_numbers_are_their_values
    assert_same in_module("f = 0x1F + 1_000"), in_module("f = 31 + 1000")
    assert_same in_module("f = 1e3"), in_module("f = 1000.0")
    refute_same in_module("f = 1"), in_module("f = 1.0")
    refute_same in_module("f = 1000"), in_module("f = 100")
  end

  def test_strings_are_their_values
    assert_includes ast(in_module('f = "a\\tb\\n"')), '"a\\tb\\n"'
    assert_equal ["a\tb\n"], literals(in_module('f = "a\\tb\\n"'))
    refute_same in_module('f = "a"'), in_module('f = "b"')
    refute_same in_module("f = 'a'"), in_module('f = "a"')
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same in_module('f = "\\65"'), in_module('f = "\\\\65"')
    refute_same in_module('f = "\\65"'), in_module('f = "\\6\\&5"')
  end

  def test_tuple_sections_stay_apart
    refute_same "{-# LANGUAGE TupleSections #-}\n#{in_module('f = (, 1)')}",
                "{-# LANGUAGE TupleSections #-}\n#{in_module('f = (1, )')}"
  end

  def test_an_operator_defined_in_brackets_is_the_operator
    signature = generate_ast(in_module("(|>) :: a -> (a -> b) -> b")).children.last.children.first
    assert_equal ["operator"], signature.children.select { |child| child.field == "name" }.map(&:type)
  end

  def test_mdo_stays_apart_from_do
    refute_same in_module("f = do\n  x <- g\n  pure x"), in_module("f = mdo\n  x <- g\n  pure x")
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
