require_relative "stage_helper"

# Tests COBOL's GenerateAST stage. Each assert_same pair is the same program
# to a COBOL compiler, and each refute_same pair is a different program.
class CobolGenerateASTTest < Minitest::Test
  include CobolStages

  def test_names_and_keywords_ignore_case
    assert_same "move Ws-X to ws-y", "MOVE WS-X TO WS-Y"
    assert_same "if ws-x display 1 end-if", "IF WS-X DISPLAY 1 END-IF"
    refute_same "DISPLAY 'a'", "DISPLAY 'A'"
  end

  def test_each_keyword_has_one_spelling
    assert_same "IF WS-X IS GREATER THAN 1 THEN DISPLAY 1", "IF WS-X > 1 DISPLAY 1"
    assert_same "IF WS-X NOT LESS THAN 1 DISPLAY 1", "IF WS-X >= 1 DISPLAY 1"
    assert_same "IF WS-X EQUALS 1 DISPLAY 1", "IF WS-X = 1 DISPLAY 1"
    assert_same "PERFORM A THROUGH B", "PERFORM A THRU B"
    assert_same "MOVE HIGH-VALUES TO WS-X", "MOVE HIGH-VALUE TO WS-X"
    assert_same "MOVE ZEROES TO WS-X", "MOVE ZERO TO WS-X"
    assert_same "COMPUTE WS-X EQUAL 1", "COMPUTE WS-X = 1"
    assert_same "MOVE 1 TO WS-X, WS-Y", "MOVE 1 TO WS-X WS-Y"
    assert_same "MOVE SPACES TO WS-X", "MOVE SPACE TO WS-X"
    assert_same "IF WS-X IS NUMERIC THEN DISPLAY 1", "IF WS-X NUMERIC DISPLAY 1"
    assert_same "IF WS-X NOT = 1 DISPLAY 1", "IF WS-X <> 1 DISPLAY 1"
    refute_same "IF WS-X > 1 DISPLAY 1", "IF WS-X < 1 DISPLAY 1"
    refute_same "IF WS-X NOT > 1 DISPLAY 1", "IF WS-X > 1 DISPLAY 1"
  end

  def test_the_words_left_out_of_the_tree_stay
    assert_equal "(move_statement move length of\n  (qualified_word ws-x) to\n  (qualified_word ws-y))",
                 statement("MOVE LENGTH OF WS-X TO WS-Y")
    refute_same "SET WS-X TO TRUE", "SET WS-X TO FALSE"
    refute_same "PERFORM WS-X TIMES DISPLAY 1 END-PERFORM", "PERFORM UNTIL WS-X DISPLAY 1 END-PERFORM"
    refute_same "DIVIDE WS-X INTO WS-Y GIVING WS-Z", "DIVIDE WS-X BY WS-Y GIVING WS-Z"
  end

  def test_the_identification_division_header_is_optional
    assert_equal ast(program), ast(program.sub("       IDENTIFICATION DIVISION.\n", ""))
  end

  def test_full_stops_and_brackets
    refute_same "IF WS-X DISPLAY 1. DISPLAY 2.", "IF WS-X DISPLAY 1 DISPLAY 2."
    refute_same "COMPUTE WS-X = (WS-X + 1) * 2", "COMPUTE WS-X = WS-X + 1 * 2"
    assert_same "DISPLAY FUNCTION TRIM (WS-X)", "DISPLAY FUNCTION TRIM(WS-X)"
  end

  def test_paragraph_and_section_names_are_names
    assert_equal "(paragraph_header main-para)", statement("Main-Para.\nDISPLAY 1.")
    assert_equal "(section_header main section)", statement("MAIN SECTION.\nDISPLAY 1.")
  end

  def test_strings_numbers_and_pictures_are_written_as_their_values
    assert_same "DISPLAY 'it''s'", 'DISPLAY "it\'s"'
    assert_same "MOVE 007 TO WS-X", "MOVE 7 TO WS-X"
    assert_same "MOVE 1.50 TO WS-X", "MOVE 1.5 TO WS-X"
    refute_same "MOVE 1 TO WS-X", "MOVE 1.0 TO WS-X"
    assert_same_data "01 WS-X PIC 9999.", "1 WS-X PIC 9(4)."
    assert_same_data "01 WS-X PIC x(2)X.", "01 WS-X PIC XXX."
    assert_same_data "01 WS-X PICTURE IS S99V99 USAGE IS COMP.", "01 WS-X PIC S9(2)V9(2) COMP."
    refute_same_data "01 WS-X PIC 9(3).", "01 WS-X PIC 9(4)."
    refute_same_data "01 WS-X PIC X.", "01 WS-X PIC A."
  end

  private
  def ast(source) = write(generate_ast(source))

  # The tree of the first statement in the PROCEDURE DIVISION.
  def statement(source)
    tree = generate_ast(program(source))
    division = tree.children.first.children.find { |child| child.type == "procedure_division" }
    write(division.children.first)
  end

  def assert_same(first, second) = assert_equal(ast(program(first)), ast(program(second)))
  def refute_same(first, second) = refute_equal(ast(program(first)), ast(program(second)))
  def assert_same_data(first, second) = assert_equal(ast(program(data: first)), ast(program(data: second)))
  def refute_same_data(first, second) = refute_equal(ast(program(data: first)), ast(program(data: second)))
end
