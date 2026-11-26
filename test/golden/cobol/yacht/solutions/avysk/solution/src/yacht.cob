       IDENTIFICATION DIVISION.
       PROGRAM-ID. YACHT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * Output
       01 WS-RESULT PIC 99 VALUE 0.
      * Inputs
       01 WS-CATEGORY PIC X(15).
       01 WS-DICE PIC 9(5).
      * Input dice as a table
       01 WS-DIGITS REDEFINES WS-DICE.
          05 WS-D OCCURS 5 TIMES PIC 9.
      * Input dice as a string
       01 WS-STR REDEFINES WS-DICE PIC X(5).
      * Counter
       77 WS-C PIC 9.
      * Index and its representation as string
       77 WS-I PIC 9.
       77 WS-S REDEFINES WS-I PIC X.
      * The lowest die in a straight
       77 WS-FROM PIC 9.
      * Count this die
       77 WS-F PIC X.
       PROCEDURE DIVISION.
       YACHT.
           INITIALIZE WS-RESULT.
           INITIALIZE WS-FROM.
           MOVE SPACE TO WS-F.
           EVALUATE WS-CATEGORY
              WHEN "ones" MOVE "1" TO WS-F
              WHEN "twos" MOVE "2" TO WS-F
              WHEN "threes" MOVE "3" TO WS-F
              WHEN "fours" MOVE "4" TO WS-F
              WHEN "fives" MOVE "5" TO WS-F
              WHEN "sixes" MOVE "6" TO WS-F
              WHEN "full house"
                 SORT WS-D ASCENDING KEY WS-D
      * If we have a full house, it consits of the first and the last
      * element now.
                 INITIALIZE WS-C
                 INSPECT WS-STR (2:4)
                    TALLYING WS-C FOR ALL WS-STR (1:1)
                 IF WS-C EQUAL TO 1
                    INITIALIZE WS-C
                    INSPECT WS-STR (2:3)
                       TALLYING WS-C FOR ALL WS-STR (5:1)
                    IF WS-C EQUAL TO 2 THEN
      * 2 + 3
                       COMPUTE WS-RESULT =
                          2 * WS-D (1) + 3 * WS-D (5)
                    END-IF
                 ELSE IF WS-C EQUAL TO 2
                    INITIALIZE WS-C
                    INSPECT WS-STR (2:3)
                       TALLYING WS-C FOR ALL WS-STR (5:1)
                    IF WS-C EQUAL TO 1 THEN
      * 3 + 2
                       COMPUTE WS-RESULT =
                          2 * WS-D (5) + 3 * WS-D (1)
                    END-IF
                 END-IF
              WHEN "four of a kind"
                 INITIALIZE WS-C
                 INSPECT WS-STR (2:4)
                    TALLYING WS-C FOR ALL WS-STR (1:1)
                 IF WS-C GREATER OR EQUAL 3 THEN
      * The first die is a part of four of a kind
                    COMPUTE WS-RESULT = 4 * WS-D (1)
                 ELSE IF WS-C EQUAL ZERO
                    INSPECT WS-STR (3:3)
                       TALLYING WS-C FOR ALL WS-STR (2:1)
                   IF WS-C EQUAL 3 THEN
      * The first die is not a part of four of a kind but the second is.
                      COMPUTE ws-result = 4 * ws-d (1)
                   END-IF
                 END-IF
              WHEN "little straight"
                 MOVE 1 TO WS-FROM
              WHEN "big straight"
                 MOVE 2 TO WS-FROM
              WHEN "choice"
                 PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I = 6
                    ADD WS-D (WS-I) TO WS-RESULT
                 END-PERFORM
              WHEN "yacht"
                 INITIALIZE WS-C
                 INSPECT WS-STR (2:4)
                    TALLYING WS-C FOR ALL WS-STR (1:1)
                 IF WS-C EQUAL 4 THEN
                    MOVE 50 TO WS-RESULT
                 END-IF.
           IF WS-F NOT EQUAL SPACE
      * Count single occurences of WS-F
              INSPECT WS-STR TALLYING WS-RESULT FOR ALL WS-F
              COMPUTE WS-RESULT = WS-RESULT * FUNCTION NUMVAL(WS-F)
           ELSE IF WS-FROM NOT EQUAL ZERO
      * We have got straight
              MOVE 30 TO WS-RESULT
              MOVE WS-FROM TO WS-I
              PERFORM 5 TIMES
                 INITIALIZE WS-C
                 INSPECT WS-STR
                    TALLYING WS-C FOR ALL WS-S
                 IF WS-C NOT EQUAL 1
                    MOVE 0 TO WS-RESULT
                    EXIT PERFORM
                 END-IF
                 ADD 1 TO WS-I
              END-PERFORM
           END-IF.
