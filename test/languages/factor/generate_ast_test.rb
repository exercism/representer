require_relative "stage_helper"

# Tests Factor's GenerateAST stage. Each assert_same pair has the same meaning
# in Factor, and each refute_same pair has different meanings.
class FactorGenerateASTTest < Minitest::Test
  include FactorStages

  def test_numbers_are_their_values
    assert_same ": f ( x -- y ) 1,000 + 1_000 + 0x1F + 1.50 + ;", ": f ( x -- y ) 1000 + 1000 + 31 + 1.5 + ;"
    refute_same ": f ( x -- y ) 1.0 + ;", ": f ( x -- y ) 1 + ;"
    refute_same ": f ( x -- y ) 1.5 + ;", ": f ( x -- y ) 1.25 + ;"
  end

  def test_brackets_and_the_end_of_a_definition_are_stripped
    assert_equal "(source_file\n  (definition : f\n    (effect\n      (inputs a)\n      (outputs b))\n    (quote dup +)))",
      ast(": f ( a -- b ) [ dup + ] ;")
  end

  def test_the_word_after_a_colon_is_the_definitions_name
    names = []
    generate_ast(": f ( a -- b ) g ;").each_descendant { |node| names << node.text if node.field == "name" }
    assert_equal ["f"], names
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
