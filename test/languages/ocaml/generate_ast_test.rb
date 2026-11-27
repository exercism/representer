require_relative "stage_helper"

# Tests OCaml's GenerateAST stage. Each assert_same pair gets the same tree
# from OCaml's parser, and each refute_same pair gets different trees.
class OCamlGenerateASTTest < Minitest::Test
  include OCamlStages

  def test_layout_and_separators_make_no_difference
    assert_same "let f x = match x with\n  | 0 -> 1\n  | _ -> 2\n", "let f x = match x with 0 -> 1 | _ -> 2"
    assert_same "let a = 1;;\nlet b = [1; 2];;\n", "let a = 1\nlet b = [1; 2;]\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "let f x = g (h x)", "let f x = g ((h x))"
    assert_same "let f a b c = (a * b) / c", "let f a b c = a * b / c"
    assert_same "let f x = begin g x end", "let f x = (g x)"
    assert_same "let f = List.fold_left ( + ) 0", "let f = List.fold_left (+) 0"
    refute_same "let f a b c = a - (b - c)", "let f a b c = a - b - c"
    refute_same "let f x = g (h x)", "let f x = g h x"
  end

  def test_a_constructor_with_a_tuple_stays_apart_from_one_with_two_arguments
    refute_same "type t = A of (int * int)", "type t = A of int * int"
  end

  def test_numbers_are_their_values
    assert_same "let x = 0x1F + 1_000", "let x = 31 + 1000"
    assert_same "let x = 1. +. 1e3", "let x = 1.0 +. 1000.0"
    refute_same "let x = 1", "let x = 1.0"
    refute_same "let x = 1L", "let x = 1"
  end

  def test_strings_are_their_values
    assert_same 'let s = "say \\"hi\\""', 'let s = {|say "hi"|}'
    assert_equal ["a\tb\n"], literals('let s = "a\\tb\\n"')
    assert_equal ["ab"], literals("let s = \"a\\\n   b\"")
    refute_same 'let s = "a"', 'let s = "b"'
    refute_same "let s = 'a'", 'let s = "a"'
    refute_same "let s = f 'a'", "let s = f a"
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'let s = "\\065"', 'let s = "\\\\065"'
    refute_same 'let s = "\\065"', 'let s = "A"'
  end

  def test_punned_labels_and_fields_are_written_in_full
    assert_same "let f ~n = n", "let f ~n:n = n"
    assert_same "let x = f ~n", "let x = f ~n:n"
    assert_same "let f { name } = name", "let f { name = name } = name"
    assert_same "let r = { name; age = 1 }", "let r = { name = name; age = 1 }"
    refute_same "let f ~n = n", "let f ?n = n"
    refute_same "let f ~n = n", "let f n = n"
  end

  def test_a_local_open_is_written_the_same_way_either_way
    assert_same "let f xs = let open List in map g xs", "let f xs = List.(map g xs)"
  end

  def test_keywords_that_change_the_meaning_stay
    refute_same "let rec f x = x", "let f x = x"
    refute_same "let f () = for i = 1 to 3 do g i done", "let f () = for i = 1 downto 3 do g i done"
    refute_same "type r = { mutable x : int }", "type r = { x : int }"
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
