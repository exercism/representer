require_relative "stage_helper"

# Tests Idris's GenerateAST stage. Each assert_same pair is code that Idris's
# parser reads the same way, ignoring spacing, and each refute_same pair is
# code that it reads differently.
class IdrisGenerateASTTest < Minitest::Test
  include IdrisStages

  def test_drops_layout
    assert_same "f : Int -> Int\nf x = x + 1\n", "f : Int->Int\nf x =\n  x+1\n"
    assert_same "f = let a = 1; b = 2 in a\n", "f = let a = 1\n        b = 2\n    in a\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "f x = (g x)\n", "f x = g x\n"
    assert_same "f (x) = (x)\n", "f x = x\n"
    assert_same "f x = if (x == 1) then (g x) else 0\n", "f x = if x == 1 then g x else 0\n"
    assert_same "f = [(g 1), 2]\n", "f = [g 1, 2]\n"
    assert_same "f : (List a) -> a\n", "f : List a -> a\n"
    assert_same "f x = case x of\n  (Just y) => y\n  _ => 0\n", "f x = case x of\n  Just y => y\n  _ => 0\n"
    refute_same "f x = (g x) + 1\n", "f x = g x + 1\n"
    refute_same "f (Just x) = x\n", "f Just x = x\n"
    refute_same "f = g (h x)\n", "f = g h x\n"
    refute_same "Show (Tree a) where\n  show _ = \"\"\n", "Show Tree a where\n  show _ = \"\"\n"
  end

  def test_keeps_operator_sections_and_tuples
    refute_same "f = map (+ 1) xs\n", "f = map + 1 xs\n"
    refute_same "f = foldr (++) [] xs\n", "f = foldr ++ [] xs\n"
    refute_same "f = (+ 1)\n", "f = + 1\n"
    refute_same "f (a, b) = a\n", "f a = a\n"
  end

  def test_brackets_at_the_end_of_a_file_are_an_expression
    assert_same "f x = (g x) - (h x)", "f x = (g x) - (h x)\n"
  end

  def test_numbers_are_their_values
    assert_same "f = 0x1F + 1_000\n", "f = 31 + 1000\n"
    assert_same "f = 1.0e3\n", "f = 1000.0\n"
    refute_same "f = 1.0\n", "f = 1\n"
  end

  def test_strings_are_their_values
    assert_same "f = \"a\\tb\"\n", "f = \"a\tb\"\n"
    assert_same "f \"a\" = 1\n", "f \"a\" = 1\n"
    refute_same "f = \"a\"\n", "f = 'a'\n"
    refute_same "f = \"a\\{x}b\"\n", "f = \"a\\{y}b\"\n"
    refute_same "f = \"\\x41\"\n", "f = \"\\x42\"\n"
    refute_same "f = \"\"\"\n  a\n  \"\"\"\n", "f = \"\"\"\n  b\n  \"\"\"\n"
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "f : Eq a => a -> Bool\n", "f : Eq a -> a -> Bool\n"
    refute_same "f = let x := 1 in x\n", "f = let x = 1 in x\n"
    refute_same "export\nf : Int\n", "public export\nf : Int\n"
    refute_same "data A = B C | D\n", "data A = B | C D\n"
    refute_same "f = [a b, c]\n", "f = [a, b c]\n"
  end

  def test_an_implementation_can_leave_out_its_keyword
    assert_same "implementation Show A where\n  show _ = \"A\"\n", "Show A where\n  show _ = \"A\"\n"
  end

  def test_a_lambda_case_can_have_a_space
    assert_same "f = \\case\n  Just x => x\n  _ => 0\n", "f = \\ case\n  Just x => x\n  _ => 0\n"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
