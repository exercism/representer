require_relative "stage_helper"

# Tests ReasonML's GenerateAST stage. Each assert_same pair gets the same
# tree from Reason's parser, and each refute_same pair gets different trees.
class ReasonmlGenerateASTTest < Minitest::Test
  include ReasonmlStages

  def test_layout_and_separators_make_no_difference
    assert_same "let f = x =>\n  switch (x) {\n  | 0 => 1\n  | _ => 2;\n  };\n", "let f = x => switch (x) { | 0 => 1 | _ => 2 }"
    assert_same "type t =\n  | A\n  | B;", "type t = A | B"
    assert_same "let a = [1, 2,];", "let a = [1, 2]"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "let f = x => g((h(x)))", "let f = x => g(h(x))"
    assert_same "let f = (a, b, c) => (a * b) / c", "let f = (a, b, c) => a * b / c"
    assert_same "let f = x => switch x { | _ => 1 }", "let f = x => switch (x) { | _ => 1 }"
    refute_same "let f = (a, b, c) => a - (b - c)", "let f = (a, b, c) => a - b - c"
  end

  def test_one_parameter_reads_the_same_with_or_without_brackets
    assert_same "let f = x => x + 1", "let f = (x) => x + 1"
  end

  def test_a_function_that_returns_a_function_is_one_function
    assert_same "let f = (x, y) => x", "let f = x => y => x"
    assert_same "let f = (x, y, z) => x", "let f = (x) => { (y, z) => x }"
    refute_same "let f = (x, y) => x", "let f = (x): (int => int) => y => x"
    refute_same "let f = () => () => 1", "let f = () => 1"
  end

  def test_braces_around_one_expression_are_dropped
    assert_same "let f = x => { x + 1 }", "let f = x => x + 1"
    assert_same "let f = x => switch (x) { | A => { 1 } }", "let f = x => switch (x) { | A => 1 }"
    assert_same "let f = x => switch (x) { | A => { g(x); 1 } }", "let f = x => switch (x) { | A => g(x); 1 }"
    refute_same "let f = x => { let y = x; y }", "let f = x => x"
  end

  def test_a_fast_pipe_reads_the_same_in_either_spelling
    assert_same "let f = x => x->g", "let f = x => x |. g"
    refute_same "let f = x => x->g", "let f = x => x |> g"
  end

  def test_operators_in_brackets_are_the_operator
    assert_same "let f = List.fold_left(( + ), 0)", "let f = List.fold_left((+), 0)"
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
    refute_same 'let s = "a"', 'let s = "b"'
    refute_same "let s = 'a'", 'let s = "a"'
    refute_same 'let s = {j|a|j}', 'let s = "a"'
    refute_same 'let s = {j|a|j}', 'let s = {js|a|js}'
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'let s = "\\065"', 'let s = "\\\\065"'
    refute_same 'let s = "\\065"', 'let s = "A"'
  end

  def test_punned_labels_and_fields_are_written_in_full
    assert_same "let f = (~n) => n", "let f = (~n as n) => n"
    assert_same "let x = f(~n)", "let x = f(~n=n)"
    assert_same "let x = f(~n?)", "let x = f(~n=?n)"
    assert_same "let f = ({name}) => name", "let f = ({name: name}) => name"
    assert_same "let r = {name, age: 1}", "let r = {name: name, age: 1}"
    refute_same "let f = (~n) => n", "let f = (n) => n"
    refute_same "let x = f(~n)", "let x = f(~n?)"
  end

  def test_keywords_and_operators_that_change_the_meaning_stay
    refute_same "let rec f = x => x", "let f = x => x"
    refute_same "let f = () => for (i in 1 to 3) { g(i) }", "let f = () => for (i in 1 downto 3) { g(i) }"
    refute_same "type r = { mutable x: int }", "type r = { x: int }"
    refute_same "let f = x => x := 1", "let f = x => x = 1"
    refute_same "let f = x => x == 1", "let f = x => x === 1"
    refute_same "let f = x => -x", "let f = x => x"
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
