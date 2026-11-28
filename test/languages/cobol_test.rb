require "test_helper"

class CobolTest < RosettaTest
  track "cobol"

  def test_comments_layout_and_comment_entries_are_ignored
    commented = fixed("* Says if a year is a leap year.", "IDENTIFICATION DIVISION.", "PROGRAM-ID. LEAP.",
                      "AUTHOR. Ada.", "DATE-WRITTEN. 2024-01-01.", "DATA DIVISION.", "WORKING-STORAGE SECTION.",
                      "01 WS-YEAR PIC 9(4).", "PROCEDURE DIVISION.", "LEAP.", "* Start with zero.",
                      "    MOVE 0      *> the answer", "      TO WS-YEAR.")
    plain = fixed("IDENTIFICATION DIVISION.", "PROGRAM-ID. LEAP.", "DATA DIVISION.", "WORKING-STORAGE SECTION.",
                  "01 WS-YEAR PIC 9(4).", "PROCEDURE DIVISION.", "LEAP.", "MOVE 0 TO WS-YEAR.")
    assert_same_representation commented, plain
  end

  def test_imports_are_dropped
    with_repository = program("DISPLAY 1.", environment: "REPOSITORY. FUNCTION ALL INTRINSIC.")
    assert_same_representation with_repository, program("DISPLAY 1.", environment: "")
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation program("PERFORM DOUBLE-IT.\nDOUBLE-IT.\nCOMPUTE WS-RESULT = WS-X * 2.",
                                       data: ["01 WS-X PIC 99.", "01 WS-RESULT PIC 999."]),
                               program("PERFORM TWICE.\nTWICE.\nCOMPUTE ANSWER = N * 2.",
                                       data: ["01 N PIC 99.", "01 ANSWER PIC 999."])
  end

  def test_names_from_outside_are_kept
    refute_parsed_same "MOVE FUNCTION UPPER-CASE(WS-X) TO WS-X.", "MOVE FUNCTION LOWER-CASE(WS-X) TO WS-X."
    refute_parsed_same "MOVE FUNCTION TRIM(WS-X) TO WS-X.", "MOVE FUNCTION REVERSE(WS-X) TO WS-X."
  end

  def test_names_and_keywords_ignore_case
    assert_same_representation program("if ws-x move 1 to ws-x\nend-if."), program("IF WS-X MOVE 1 TO WS-X\nEND-IF.")
    assert_same_representation program("MOVE 1 TO Ws-X.", data: ["01 ws-x PIC 9."]),
                               program("MOVE 1 TO WS-X.", data: ["01 WS-X PIC 9."])
  end

  def test_spellings_that_cobol_reads_the_same_way_share_a_representation
    assert_same_representation program("IF WS-X IS GREATER THAN 1 THEN DISPLAY 1."), program("IF WS-X > 1 DISPLAY 1.")
    assert_same_representation program("IF WS-X IS NOT EQUAL TO 1 DISPLAY 1."), program("IF WS-X <> 1 DISPLAY 1.")
    assert_same_representation program("MOVE ZEROS TO WS-X, WS-Y."), program("MOVE ZERO TO WS-X WS-Y.")
    assert_same_representation program("COMPUTE WS-X EQUAL 007."), program("COMPUTE WS-X = 7.")
    assert_same_representation program("DISPLAY 'it''s'."), program('DISPLAY "it\'s".')
    assert_same_representation program("DISPLAY 1.", data: ["01 WS-X PICTURE IS 9999 USAGE IS DISPLAY."]),
                               program("DISPLAY 1.", data: ["1 WS-X PIC 9(4) DISPLAY."])
  end

  def test_words_the_grammar_leaves_out_of_its_tree_keep_solutions_apart
    refute_parsed_same "MOVE LENGTH OF WS-X TO WS-Y.", "MOVE WS-X TO WS-Y."
    refute_parsed_same "SET WS-X TO TRUE.", "SET WS-X TO FALSE."
    refute_parsed_same "PERFORM WS-X TIMES DISPLAY 1 END-PERFORM.", "PERFORM UNTIL WS-X DISPLAY 1 END-PERFORM."
    refute_parsed_same "DIVIDE WS-X INTO WS-Y GIVING WS-Z.", "DIVIDE WS-X BY WS-Y GIVING WS-Z."
    refute_parsed_same "ADD WS-X TO WS-Y.", "ADD WS-X GIVING WS-Y."
    refute_parsed_same "DISPLAY FUNCTION TRIM(WS-X LEADING).", "DISPLAY FUNCTION TRIM(WS-X TRAILING)."
    refute_parsed_same "INSPECT WS-X TALLYING WS-N FOR CHARACTERS.", "INSPECT WS-X TALLYING WS-N FOR ALL WS-Y."
  end

  def test_things_that_must_stay_apart
    refute_parsed_same "COMPUTE WS-X = (WS-X + 1) * 2.", "COMPUTE WS-X = WS-X + 1 * 2."
    refute_parsed_same "IF (WS-X OR WS-Y) AND WS-Z DISPLAY 1.", "IF WS-X OR WS-Y AND WS-Z DISPLAY 1."
    refute_parsed_same "IF WS-X > 1 DISPLAY 1.", "IF WS-X >= 1 DISPLAY 1."
    refute_parsed_same "IF WS-X DISPLAY 1. DISPLAY 2.", "IF WS-X DISPLAY 1 DISPLAY 2."
    refute_parsed_same "DISPLAY 'a'.", "DISPLAY 'A'."
    refute_parsed_same "DISPLAY 1.", "DISPLAY 1.0."
    refute_same_representation program("DISPLAY 1.", data: ["01 WS-X PIC X(3)."]),
                               program("DISPLAY 1.", data: ["01 WS-X PIC 9(3)."])
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "       IDENTIFICATION DIVISION.\n       PROGRAM-ID. A.\n       PROCEDURE DIVISION.\n       MOVE.\n"
  end

  private
  # A program with these statements in its PROCEDURE DIVISION, written
  # from the eighth column, as COBOL's fixed format needs.
  def program(statements, data: ["01 WS-X PIC 99.", "01 WS-Y PIC 99.", "01 WS-Z PIC 99.", "01 WS-N PIC 99."],
              environment: nil)
    lines = ["IDENTIFICATION DIVISION.", "PROGRAM-ID. P."]
    lines += ["ENVIRONMENT DIVISION.", "CONFIGURATION SECTION.", environment].reject(&:empty?) if environment
    lines += ["DATA DIVISION.", "WORKING-STORAGE SECTION.", *data, "PROCEDURE DIVISION.", "MAIN.", *statements.lines]
    fixed(*lines.map(&:chomp))
  end

  # The lines in COBOL's fixed format: a comment line has its `*` in the
  # seventh column, and code starts in the eighth.
  def fixed(*lines) = lines.map { |line| line.start_with?("*") ? "      #{line}\n" : "       #{line}\n" }.join

  # Both statements must parse, so a syntax error can't pass the test.
  def refute_parsed_same(statements, other)
    representations = [statements, other].map { |code| represent(program(code)).representation }
    representations.each { |representation| refute representation.start_with?("basic"), representation }
    refute_equal(*representations)
  end
end
