      * ----------------------------------------------------------------------
      * exercism.io
      * COBOL Track Exercise: isogram
      * Contributed: Anthony J. Borla (ajborla@bigpond.com)
      * ----------------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ISOGRAM.
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
       01 WS-PHRASE               PIC X(60) VALUE SPACES.
       01 WS-RESULT               PIC 9(01).
      *
       01 WS-CONSTANTS.
          05 WS-OPERATION-STATUS.
             10 WS-IS-ISOGRAM     PIC 9(01) VALUE 1.
             10 WS-NOT-ISOGRAM    PIC 9(01) VALUE ZEROES.
      *
       01 WS-SCRATCHPAD.
          05 WS-PHRASE-LENGTH     PIC 9(02).
          05 WS-IDX               PIC 9(02).
      *
       01 WS-COUNT-TABLE-LENGTH   PIC 9(02) VALUE 26.
       01 WS-COUNT-TABLE.
          05 WS-COUNT             PIC 9(02)
                                  OCCURS 26 TIMES.
      *
       PROCEDURE DIVISION.
      *
       ISOGRAM.
           COMPUTE WS-PHRASE-LENGTH =
             FUNCTION LENGTH(FUNCTION TRIM(WS-PHRASE))
      *
           IF WS-PHRASE-LENGTH < 1 THEN
             MOVE WS-IS-ISOGRAM TO WS-RESULT
             EXIT PARAGRAPH
           END-IF
      *
           MOVE WS-IS-ISOGRAM TO WS-RESULT
      *
           MOVE ZEROES TO WS-COUNT-TABLE
      *
           INSPECT FUNCTION UPPER-CASE(WS-PHRASE)
             TALLYING WS-COUNT(1) FOR ALL 'A'
                      WS-COUNT(2) FOR ALL 'B'
                      WS-COUNT(3) FOR ALL 'C'
                      WS-COUNT(4) FOR ALL 'D'
                      WS-COUNT(5) FOR ALL 'E'
                      WS-COUNT(6) FOR ALL 'F'
                      WS-COUNT(7) FOR ALL 'G'
                      WS-COUNT(8) FOR ALL 'H'
                      WS-COUNT(9) FOR ALL 'I'
                      WS-COUNT(10) FOR ALL 'J'
                      WS-COUNT(11) FOR ALL 'K'
                      WS-COUNT(12) FOR ALL 'L'
                      WS-COUNT(13) FOR ALL 'M'
                      WS-COUNT(14) FOR ALL 'N'
                      WS-COUNT(15) FOR ALL 'O'
                      WS-COUNT(16) FOR ALL 'P'
                      WS-COUNT(17) FOR ALL 'Q'
                      WS-COUNT(18) FOR ALL 'R'
                      WS-COUNT(19) FOR ALL 'S'
                      WS-COUNT(20) FOR ALL 'T'
                      WS-COUNT(21) FOR ALL 'U'
                      WS-COUNT(22) FOR ALL 'V'
                      WS-COUNT(23) FOR ALL 'W'
                      WS-COUNT(24) FOR ALL 'X'
                      WS-COUNT(25) FOR ALL 'Y'
                      WS-COUNT(26) FOR ALL 'Z'
      *
           MOVE 1 TO WS-IDX
      *
           PERFORM WS-COUNT-TABLE-LENGTH TIMES
             IF WS-COUNT(WS-IDX) > 1 THEN
               MOVE WS-NOT-ISOGRAM TO WS-RESULT
               EXIT PARAGRAPH
             END-IF
             ADD 1 TO WS-IDX
           END-PERFORM.
      *