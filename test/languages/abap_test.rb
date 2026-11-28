require "test_helper"

# Tests Inspector as a whole on ABAP solutions. The tests of each stage are in
# test/languages/abap/.
class AbapTest < InspectorTest
  track "abap"

  def test_comments_layout_and_case_go
    assert_same_representation "CLASS zcl_leap IMPLEMENTATION.\n* Says if a year is a leap year.\n" \
                               "  METHOD leap.\n    \"! The rule\n    result = xsdbool( year MOD 4 = 0 ). \" done\n" \
                               "  ENDMETHOD.\nENDCLASS.\n",
                               "class zcl_leap implementation. method leap.\n" \
                               "result = xsdbool( Year mod 4 eq 0 ). endmethod. endclass.\n"
  end

  def test_names_the_solution_defines_are_renamed
    code = "CLASS %<c>s DEFINITION.\n  PUBLIC SECTION.\n    METHODS %<m>s IMPORTING %<i>s TYPE i RETURNING VALUE(%<r>s) TYPE i.\n" \
           "ENDCLASS.\nCLASS %<c>s IMPLEMENTATION.\n  METHOD %<m>s.\n    DATA(%<d>s) = %<i>s * 2.\n    %<r>s = %<d>s.\n" \
           "  ENDMETHOD.\nENDCLASS.\n"
    assert_same_representation format(code, c: "zcl_a", m: "run", d: "double", i: "input", r: "result"),
                               format(code, c: "zcl_b", m: "go", d: "twice", i: "amount", r: "output")
  end

  def test_names_from_the_library_keep_their_names
    refute_same_representation "CLASS c IMPLEMENTATION.\n  METHOD m.\n    r = to_upper( s ).\n  ENDMETHOD.\nENDCLASS.\n",
                               "CLASS c IMPLEMENTATION.\n  METHOD m.\n    r = to_lower( s ).\n  ENDMETHOD.\nENDCLASS.\n"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation "CLASS c IMPLEMENTATION.\n  METHOD m.\n    r = |a{ 007 }|.\n  ENDMETHOD.\nENDCLASS.\n",
                               "CLASS c IMPLEMENTATION.\n  METHOD m.\n    r = |a{ 7 }|.\n  ENDMETHOD.\nENDCLASS.\n"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_abap_version
    assert_basic_representation "CLASS c IMPLEMENTATION.\n  METHOD m.\n    r = ( .\n"
  end
end
