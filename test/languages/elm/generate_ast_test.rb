require_relative "stage_helper"

# Tests Elm's GenerateAST stage. Each assert_same pair is code that the Elm
# compiler's parser reads as the same tree, and each refute_same pair is
# code that it reads as different trees.
class ElmGenerateASTTest < Minitest::Test
  include ElmStages

  def test_brackets_that_only_group_are_dropped
    assert_same wrap("g (h x)"), wrap("g   (h  x)")
    assert_same wrap("(x)"), wrap("x")
    assert_same wrap("((x))"), wrap("x")
    assert_same wrap("(modBy 2 x) + g (x // 2)"), wrap("modBy 2 x + g (x // 2)")
    assert_same wrap("(x + 1)"), wrap("x + 1")
    refute_same wrap("g (h x)"), wrap("g h x")
  end

  def test_brackets_around_an_operator_expression_inside_another_are_kept
    refute_same wrap("(x + y) * 2"), wrap("x + y * 2")
    refute_same wrap("x - (y - 1)"), wrap("x - y - 1")
    assert_same wrap("((x + y)) * 2"), wrap("(x + y) * 2")
  end

  def test_numbers_are_their_values
    assert_same wrap("0x1F"), wrap("31")
    assert_same wrap("1.50"), wrap("1.5")
    assert_same wrap("1.5e1"), wrap("15.0")
    refute_same wrap("1.0"), wrap("1")
    refute_same wrap("0x1F"), wrap("0x1E")
  end

  def test_strings_are_their_values
    assert_same wrap("\"a\\u{41}\""), wrap("\"aA\"")
    assert_same wrap('"\\u{5C}\\u{A}"'), wrap('"\\\\\\n"')
    assert_same wrap("\"\"\"a\"\"\""), wrap("\"a\"")
    refute_same wrap("\"a\""), wrap("\"b\"")
    refute_same wrap("\"a\\u{D800}\""), wrap("\"a\"")
  end

  def test_the_module_name_is_marked
    assert_includes ast("module Leap exposing (..)\n"), "(module_name Leap)"
  end

  def test_constrained_type_variables_are_marked
    tree = generate_ast("module M exposing (..)\n\nf : number -> comparable2 -> a\nf = g\n")
    constrained = []
    tree.each_descendant { |node| constrained << node.text if node.type == "constrained_type_variable" }
    assert_equal %w[number comparable2], constrained
  end

  def test_the_variable_of_an_extensible_record_type_is_a_type_variable
    assert_includes ast("module M exposing (..)\n\nf : { a | x : Int } -> Int\nf r = r.x\n"), "(type_variable a)"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
