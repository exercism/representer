require_relative "stage_helper"

# Tests ABAP's GenerateAST stage. Each assert_same pair is code that the ABAP
# compiler's parser reads the same way, ignoring spacing, and each
# refute_same pair is code that it reads differently.
class AbapGenerateASTTest < Minitest::Test
  include AbapStages

  def test_drops_layout
    assert_same in_method("x = f( a ).\ny = 2."), in_method("x = f(   a ). y = 2.")
    assert_same in_method("x = ( a + b ) * c."), in_method("x = ( a + b ) * ( c ).")
    assert_same in_method("x = a + b."), in_method("x = ( a + b ).")
    refute_same in_method("x = ( a + b ) * c."), in_method("x = a + b * c.")
  end

  def test_names_and_keywords_ignore_case
    assert_same in_method("IF Year MOD 4 = 0. Result = abap_true. ENDIF."),
                in_method("if year mod 4 = 0. result = ABAP_TRUE. endif.")
    assert_same in_method("FIELD-SYMBOLS <Line> TYPE i."), in_method("field-symbols <line> type i.")
  end

  def test_chained_statements_are_split
    assert_same in_method("DATA: a TYPE i, b TYPE string."), in_method("DATA a TYPE i.\nDATA b TYPE string.")
    assert_same in_method("DATA: a TYPE i."), in_method("DATA a TYPE i.")
    assert_same in_method("CLEAR: a, b."), in_method("CLEAR a. CLEAR b.")
    assert_same "TYPES: BEGIN OF ty, a TYPE i, END OF ty.\n", "TYPES BEGIN OF ty.\nTYPES a TYPE i.\nTYPES END OF ty.\n"
    refute_same in_method("DATA: a TYPE i, b TYPE i."), in_method("DATA a TYPE i.")
  end

  def test_both_spellings_of_comparisons_are_the_same
    assert_same in_method("IF a EQ b OR a NE b. ENDIF."), in_method("IF a = b OR a <> b. ENDIF.")
    assert_same in_method("IF a LT b OR a GT b. ENDIF."), in_method("IF a < b OR a > b. ENDIF.")
    assert_same in_method("IF a LE b OR a GE b. ENDIF."), in_method("IF a <= b OR a >= b. ENDIF.")
    refute_same in_method("IF a LT b. ENDIF."), in_method("IF a <= b. ENDIF.")
  end

  def test_escaped_names_and_explicit_exporting_are_dropped
    assert_same "METHODS m IMPORTING !year TYPE i.\n", "METHODS m IMPORTING year TYPE i.\n"
    assert_same in_method("x = f( EXPORTING a = 1 )."), in_method("x = f( a = 1 ).")
    refute_same "METHODS m IMPORTING VALUE(year) TYPE i.\n", "METHODS m IMPORTING year TYPE i.\n"
  end

  def test_numbers_are_their_values
    assert_same in_method("x = 007."), in_method("x = 7.")
    refute_same in_method("x = -1."), in_method("x = 1.")
  end

  def test_strings_are_their_values
    template = generate_ast("x = |a\\n{ b }\\||.").children[0].children.last
    assert_equal "(string_template \"a\\n\"\n  (embedded_expression b) \"|\")", write(template)
    refute_same in_method("x = 'abc'."), in_method("x = `abc`.")
    refute_same in_method("x = 'abc'."), in_method("x = 'ABC'.")
    refute_same in_method("x = 'a '."), in_method("x = 'a'.")
    refute_same in_method("x = |abc|."), in_method("x = `abc`.")
    refute_same in_method("x = |a\\nb|."), in_method("x = |a\\tb|.")
    refute_same in_method("x = |{ a }{ b }|."), in_method("x = |{ a } { b }|.")
  end

  def test_field_symbols_and_variables_stay_apart
    refute_same in_method("x = <line>."), in_method("x = line.")
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same in_method("x = a."), in_method("x ?= a.")
    refute_same in_method("x = a-b."), in_method("x = a->b.")
    refute_same in_method("x = a=>b."), in_method("x = a->b.")
    refute_same in_method("x = a + b."), in_method("x = a - b.")
    refute_same in_method("x += 1."), in_method("x -= 1.")
    refute_same in_method("IF a = b AND c = d. ENDIF."), in_method("IF a = b OR c = d. ENDIF.")
    refute_same in_method("LOOP AT t INTO DATA(l). ENDLOOP."), in_method("LOOP AT t REFERENCE INTO DATA(l). ENDLOOP.")
    refute_same "METHODS m IMPORTING a TYPE i.\n", "METHODS m EXPORTING a TYPE i.\n"
    refute_same "DATA a TYPE i.\n", "CONSTANTS a TYPE i VALUE 0.\n"
  end

  private
  def in_method(code) = "CLASS c IMPLEMENTATION.\n  METHOD m.\n#{code}\n  ENDMETHOD.\nENDCLASS.\n"
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
