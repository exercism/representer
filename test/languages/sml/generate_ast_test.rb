require_relative "stage_helper"

# Tests Standard ML's GenerateAST stage. Each assert_same pair gets the same
# tree from an SML compiler's parser, and each refute_same pair gets
# different trees.
class SmlGenerateASTTest < Minitest::Test
  include SmlStages

  def test_layout_and_separators_make_no_difference
    assert_same "fun f 0 = 1\n  | f n = 2;\nval x = 1;", "fun f 0 = 1 | f n = 2 val x = 1"
    assert_same "val y = case x of | A => 1 | B => 2", "val y = case x of A => 1 | B => 2"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "val y = f (g x)", "val y = f ((g x))"
    assert_same "val y = (a * b) + c", "val y = a * b + c"
    assert_same "val y = (f a) b", "val y = f a b"
    assert_same "val y = f (x)", "val y = f x"
    assert_same "fun f (x) = x", "fun f x = x"
    refute_same "val y = a - (b - c)", "val y = a - b - c"
    refute_same "val y = f (g x)", "val y = f g x"
    refute_same "val y = (a + b) * c", "val y = a + b * c"
  end

  def test_operators_are_grouped_by_their_precedence
    assert_same "val y = a + (b * c)", "val y = a + b * c"
    assert_same "val y = (f a) + (g b)", "val y = f a + g b"
    assert_same "val y = a :: (b :: c)", "val y = a :: b :: c"
    assert_same "val y = (a = b) andalso c", "val y = a = b andalso c"
    assert_same "fun f (x :: (y :: ys)) = x", "fun f (x :: y :: ys) = x"
    refute_same "val y = (a :: b) :: c", "val y = a :: b :: c"
    refute_same "val y = a + b", "val y = a - b"
  end

  def test_an_infix_declaration_changes_how_operators_group
    assert_same "infix 7 |>\nval y = a + (b |> c)", "infix 7 |>\nval y = a + b |> c"
    refute_same "infix 7 |>\nval y = a + b |> c", "infix 1 |>\nval y = a + b |> c"
    assert_same "infixr 5 ++\nval y = a ++ (b ++ c)", "infixr 5 ++\nval y = a ++ b ++ c"
    assert_same "infix |>", "infix 0 |>"
  end

  def test_an_operator_with_op_is_a_value
    assert_same "val y = foldl (op +) 0 xs", "val y = foldl op+ 0 xs"
    refute_same "val y = op + (a, b)", "val y = a + b"
  end

  def test_numbers_are_their_values
    assert_same "val x = 0x1F + 1_000", "val x = 31 + 1000"
    assert_same "val x = 2.50 + 1e3", "val x = 2.5 + 1000.0"
    refute_same "val x = 1", "val x = 1.0"
    refute_same "val x = 0w1", "val x = 1"
    refute_same "val x = 010", "val x = 8"
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n\"\\"], literals('val s = "a\\tb\\n\\"\\\\"')
    assert_equal ["ab"], literals("val s = \"a\\\n   \\b\"")
    refute_same 'val s = "a"', 'val s = "b"'
    refute_same 'val s = #"a"', 'val s = "a"'
    refute_same 'val s = f #"a"', "val s = f a"
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'val s = "\\065"', 'val s = "\\\\065"'
    refute_same 'val s = "\\065"', 'val s = "A"'
  end

  def test_punned_record_fields_are_written_in_full
    assert_same "fun f {name} = name", "fun f {name = name} = name"
    refute_same "fun f {name, ...} = name", "fun f {name} = name"
  end

  def test_keywords_and_signs_that_change_the_meaning_stay
    refute_same "val rec f = fn x => x", "val f = fn x => x"
    refute_same "structure S :> T = struct end", "structure S : T = struct end"
    refute_same "exception E = Fail", "exception E of Fail"
    refute_same "local val a = 1 in val b = a end", "local in val a = 1 val b = a end"
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
