require_relative "stage_helper"

# Checks ABAP's declarations of which nodes are names and which nodes define
# them (see abap/representation.rb), through the engine's renaming.
class AbapNamesTest < Minitest::Test
  include AbapStages

  def test_renames_classes_methods_and_their_parameters
    source = "CLASS zcl_leap DEFINITION PUBLIC.\n  PUBLIC SECTION.\n" \
             "    METHODS leap IMPORTING !year TYPE i EXPORTING REFERENCE(count) TYPE i\n" \
             "      RETURNING VALUE(result) TYPE abap_bool.\nENDCLASS.\n" \
             "CLASS zcl_leap IMPLEMENTATION.\n  METHOD leap.\n    result = xsdbool( year MOD 4 = 0 ).\n" \
             "  ENDMETHOD.\nENDCLASS.\n"
    assert_equal %w[count leap result year zcl_leap], renamed(source)
  end

  def test_renames_types_components_variables_and_constants
    source = "TYPES: BEGIN OF ty_pair, key TYPE string, END OF ty_pair.\nTYPES ty_pairs TYPE STANDARD TABLE OF ty_pair.\n" \
             "DATA pairs TYPE ty_pairs.\nCONSTANTS c_max TYPE i VALUE 10.\nCLASS-DATA cache TYPE string.\n" \
             "STATICS calls TYPE i.\nFIELD-SYMBOLS <pair> TYPE ty_pair.\n"
    assert_equal %w[<pair> c_max cache calls key pairs ty_pair ty_pairs], renamed(source)
  end

  def test_renames_inline_declarations_iterations_and_let
    source = "DATA(n) = 0.\nLOOP AT t ASSIGNING FIELD-SYMBOL(<l>). ENDLOOP.\n" \
             "x = REDUCE i( INIT s = 0 FOR w IN t INDEX INTO idx NEXT s = s + idx ).\n" \
             "y = VALUE #( FOR i = 0 WHILE i < 3 ( i ) ).\nz = VALUE #( LET h = 2 IN ( h ) ).\n"
    assert_equal %w[<l> h i idx n s w x y z], renamed(source)
  end

  def test_renames_names_in_any_case
    assert_equal %w[count], renamed("DATA Count TYPE i.\ncount = COUNT + 1.\n")
    counts = marks("DATA Count TYPE i.\ncount = COUNT.\n").select { |text, _| text == "count" }
    assert_equal [true, true, true], counts.map(&:last)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[x], renamed("x = to_upper( val = sy-datum ).\n")
    assert_equal %w[x], renamed("x = cl_abap_char_utilities=>newline.\n")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Abap::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Abap::Representation::Spec.name?(node) }
    leaves
  end
end
