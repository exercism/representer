require_relative "stage_helper"

# Tests Ballerina's GenerateAST stage. Ballerina's grammar only splits the
# code into tokens, so each assert_same pair gets the same list of tokens
# from Ballerina's own lexer, and each refute_same pair gets different ones.
class BallerinaGenerateASTTest < Minitest::Test
  include BallerinaStages

  def test_drops_comments_and_layout
    assert_same "// c\n# doc\nfunction f() { }", "function f() { }"
    assert_same "function f() { return a+b; }", "function f() {\n  return   a + b ;\n}"
  end

  def test_keeps_every_bracket
    refute_same "function f() { return (a + b) * a; }", "function f() { return a + b * a; }"
  end

  def test_quoted_names_are_plain_names
    assert_same "function f() { int 'total = 1; }", "function f() { int total = 1; }"
  end

  def test_template_text_is_its_value
    assert_includes ast("function f() { string s = string `Hello, ${a}!`; }"), '"Hello, "'
    refute_same "function f() { string s = string `Hello, ${a}!`; }", "function f() { string s = string `Hi, ${a}!`; }"
    refute_same "function f() { string s = string `a`; }", 'function f() { string s = "a"; }'
  end

  def test_floats_are_their_values
    assert_same "function f() { float x = 1.50; }", "function f() { float x = 1.5; }"
    refute_same "function f() { decimal x = 1.50d; }", "function f() { decimal x = 1.5d; }"
    refute_same "function f() { float x = 1.5; }", "function f() { float x = 1.6; }"
  end

  def test_wraps_the_names_of_functions_and_types
    assert_includes ast("function add(int x) returns int { return x; }"), "(function_name add)"
    assert_includes ast("type P record {| int x; |};"), "(type_name P)"
    assert_includes ast("class Counter { }"), "(type_name Counter)"
    assert_includes ast("enum Colour { RED }"), "(type_name Colour)"
  end

  def test_wraps_the_names_of_variables_and_parameters
    source = "function f(int a, Person p) { int[] xs = []; foreach int i in xs { } }"
    ["(variable a)", "(variable p)", "(variable xs)", "(variable i)"].each { |name| assert_includes ast(source), name }
  end

  def test_wraps_the_parameters_of_a_lambda
    source = "function f() { var g = (m, n) => m + n; var h = x => x; }"
    ["(variable m)", "(variable n)", "(variable x)"].each { |name| assert_includes ast(source), name }
  end

  def test_leaves_record_fields_members_and_resource_names
    refute_includes ast("type P record {| int x; |};"), "(variable x)"
    refute_includes ast("function f() { p.x = 1; }"), "(variable x)"
    refute_includes ast("service / on l { resource function get greeting() { } }"), "(function_name"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
