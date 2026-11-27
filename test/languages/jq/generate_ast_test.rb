require_relative "stage_helper"

# Tests jq's GenerateAST stage. Each assert_same pair gets the same tree
# from jq's own parser, and each refute_same pair gets different trees.
class JqGenerateASTTest < Minitest::Test
  include JqStages

  def test_layout_makes_no_difference
    assert_same "def f:\n  . + 1\n;", "def f: .+1;"
    assert_same "[1,2,3]", "[ 1, 2, 3 ]"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "{a: (.b)}", "{a: .b}"
    assert_same ".[(.a | f)]", ".[.a | f]"
    refute_same "(. + 1) * 2", ". + 1 * 2"
  end

  def test_numbers_are_their_values
    assert_same ".8", "0.8"
    assert_same "1.50", "1.5"
    assert_same "1e3", "1000.0"
    refute_same "1", "1.0"
    refute_same "1", "2"
  end

  def test_strings_are_their_values
    assert_same '"a\(.b)c"', '"a\( .b )c"'
    refute_same '"a\(.b)"', '"a.b"'
    refute_same '"a\tb"', '"a b"'
    refute_same '"a"', '"A"'
  end

  def test_fields_are_indexes
    assert_same ".a", '."a"'
    assert_same ".a", '.["a"]'
    assert_same ".a.b", '.a["b"]'
    refute_same ".a.b", ".a | .b"
    refute_same ".a", ".b"
  end

  def test_object_keys_are_strings
    assert_same "{a: 1}", '{"a": 1}'
    assert_same "{a}", "{a: .a}"
    assert_same '{"a"}', "{a: .a}"
    assert_same "{$a}", "{a: $a}"
    assert_same ". as {$a} | $a", ". as {a: $a} | $a"
    refute_same "{a: 1}", "{b: 1}"
    refute_same "{(.a): 1}", "{a: 1}"
  end

  def test_an_optional_expression_is_a_try
    assert_same ".a?", "try .a"
    refute_same "try .a", "try .a catch 1"
  end

  def test_an_elif_is_an_if_inside_an_else
    assert_same "if . then 1 elif .a then 2 else 3 end", "if . then 1 else if .a then 2 else 3 end end"
    assert_same "if . then 1 end", "if . then 1 else . end"
    refute_same "if . then 1 else 2 end", "if . then 2 else 1 end"
  end

  def test_code_that_changes_the_meaning_stays
    refute_same ".[1:]", ".[:1]"
    refute_same ".[]", "."
    refute_same ". as [$a, $b] | $a", ". as [$a] ?// $b | $a"
    refute_same ".a // 1", ".a or 1"
    refute_same ".a |= 1", ".a = 1"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
