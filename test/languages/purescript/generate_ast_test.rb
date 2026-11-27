require_relative "stage_helper"

# Tests PureScript's GenerateAST stage. Each assert_same pair has the same
# meaning in PureScript, and each refute_same pair has different meanings.
class PureScriptGenerateASTTest < Minitest::Test
  include PureScriptStages

  def test_layout_makes_no_difference
    assert_same in_module("f x = do\n  log x\n  log x"), in_module("f x =\n  do\n    log x\n    log x")
    assert_same in_module("f x\n  | x > 0 = 1\n  | otherwise = 0"), in_module("f x | x > 0 = 1 | otherwise = 0")
  end

  def test_unicode_syntax_is_the_same_as_ascii
    assert_same in_module("f ∷ ∀ a. a → a\nf x = x"), in_module("f :: forall a. a -> a\nf x = x")
    assert_same in_module("f = \\x → x"), in_module("f = \\x -> x")
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_module("f x = g (h x)"), in_module("f x = g ((h x))")
    assert_same in_module("f = case x of\n  (Just y) -> y\n  _ -> 0"), in_module("f = case x of\n  Just y -> y\n  _ -> 0")
    refute_same in_module("f x = g (h x)"), in_module("f x = g h x")
  end

  def test_brackets_inside_an_operator_expression_stay
    refute_same in_module("f a b c = (a + b) * c"), in_module("f a b c = a + b * c")
    refute_same in_module("f a b = a - (-b)"), in_module("f a b = a - -b")
    refute_same in_module("f a b = ((a + b) * _)"), in_module("f a b = (a + b * _)")
    refute_same in_module("f :: (Int -> Int) -> Int"), in_module("f :: Int -> Int -> Int")
  end

  def test_numbers_are_their_values
    assert_same in_module("f = 0xFF + 1_000"), in_module("f = 255 + 1000")
    refute_same in_module("f = 1"), in_module("f = 1.0")
    refute_same in_module("f = 1000"), in_module("f = 100")
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n"], literals(in_module('f = "a\\tb\\n"'))
    assert_same in_module('f = """a"""'), in_module('f = "a"')
    refute_same in_module('f = """a\\n"""'), in_module('f = "a\\n"')
    refute_same in_module("f = 'a'"), in_module('f = "a"')
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same in_module('f = "\\x41"'), in_module('f = "\\\\x41"')
  end

  def test_record_puns_are_written_in_full
    assert_same in_module("f x = { x }"), in_module("f x = { x: x }")
    assert_same in_module("f { x } = x"), in_module("f { x: x } = x")
  end

  def test_booleans_in_patterns_stay_apart
    refute_same in_module("f = case x of\n  Just true -> 1\n  _ -> 0"), in_module("f = case x of\n  Just false -> 1\n  _ -> 0")
  end

  def test_ado_stays_apart_from_do
    refute_same in_module("f = do\n  x <- g\n  pure x"), in_module("f = ado\n  x <- g\n  in x")
  end

  def test_derive_newtype_stays_apart_from_derive
    refute_same in_module("derive newtype instance showN :: Show N"), in_module("derive instance showN :: Show N")
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
