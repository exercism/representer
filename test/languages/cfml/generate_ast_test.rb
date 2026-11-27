require_relative "stage_helper"

# Tests CFML's GenerateAST stage. Each assert_same pair gets the same tree
# from a CFML engine's parser, and each refute_same pair gets different
# trees.
class CFMLGenerateASTTest < Minitest::Test
  include CFMLStages

  def test_layout_and_semicolons_make_no_difference
    assert_same "component {\n  function f() {\n    return 1;\n  }\n}", "component { function f() { return 1 } }"
    assert_same "f();;", "f();"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "x = (a * b) + c;", "x = a * b + c;"
    assert_same "return (true);", "return true;"
    refute_same "x = (a + b) * c;", "x = a + b * c;"
    refute_same "x = a - (b - c);", "x = a - b - c;"
  end

  def test_case_makes_no_difference_outside_strings
    assert_same "COMPONENT { PUBLIC FUNCTION F(X) { RETURN ArrayLen(X) GT 0 AND TRUE; } }",
                "component { public function f(x) { return arraylen(x) > 0 && true; } }"
    refute_same 'x = "A";', 'x = "a";'
  end

  def test_word_operators_are_their_symbols
    assert_same "x = a EQ b;", "x = a == b;"
    assert_same "x = a IS b;", "x = a == b;"
    assert_same "x = a IS NOT b;", "x = a != b;"
    assert_same "x = a <> b;", "x = a != b;"
    assert_same "x = a GTE b OR a LESS THAN c;", "x = a >= b || a < c;"
    assert_same "x = a MOD 4;", "x = a % 4;"
    assert_same "x = NOT a;", "x = !a;"
    refute_same "x = a === b;", "x = a == b;"
    refute_same "x = a CONTAINS b;", "x = a == b;"
  end

  def test_strings_are_their_values
    assert_same "x = 'a';", 'x = "a";'
    assert_same "x = 'it''s';", %(x = "it's";)
    assert_same 'x = "say ""hi""";', %(x = 'say "hi"';)
    assert_same 'x = "a##b";', "x = 'a##b';"
    assert_equal ["it's", "a#b"], literals(%(x = 'it''s' & "a##b";))
    refute_same 'x = "#a#";', "x = a;"
  end

  def test_numbers_are_their_values
    assert_same "x = 010;", "x = 10;"
    assert_same "x = 1.50;", "x = 1.5;"
    refute_same "x = 1.0;", "x = 1;"
  end

  def test_struct_literals_with_equals_and_colons_are_the_same
    assert_same 'x = {a = 1, "b" = 2};', 'x = {a: 1, "b": 2};'
    assert_same "x = {};", "x = {};"
    refute_same 'x = {a = 1};', 'x = {"a" = 1};'
  end

  def test_parameters_have_their_parts_in_fields
    assert_same "component { function f(required string name, n = 1) {} }",
                "component { function f( required string name , n=1 ) {} }"
    refute_same "component { function f(string name) {} }", "component { function f(name) {} }"
    refute_same "component { function f(required name) {} }", "component { function f(name) {} }"
  end

  def test_an_arrow_functions_lone_parameter_is_in_brackets
    assert_same "f = x => x * 2;", "f = (x) => x * 2;"
    refute_same "f = (x) => x * 2;", "f = (x) -> x * 2;"
  end

  def test_elseif_is_else_if
    assert_same "if (a) { x = 1; } elseif (b) { x = 2; }", "if (a) { x = 1; } else if (b) { x = 2; }"
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
