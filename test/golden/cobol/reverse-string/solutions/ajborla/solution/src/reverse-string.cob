      * ----------------------------------------------------------------------
      * exercism.io
      * COBOL Track Exercise: reverse-string
      * Contributed: Anthony J. Borla (ajborla@bigpond.com)
      * ----------------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. REVERSE-STRING.
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
       01 WS-STRING               PIC X(64) VALUE SPACES.
       01 WS-CHAR-TABLE           REDEFINES WS-STRING.
          05 WS-CHAR              PIC X(01)
                                  OCCURS 64 TIMES.
      *
       01 WS-SCRATCHPAD.
          05 WS-STRING-LENGTH     PIC 9(02).
          05 WS-STRING-STEPS      PIC 9(02).
          05 WS-CHAR-IDX-LEFT     PIC 9(02).
          05 WS-CHAR-IDX-RIGHT    PIC 9(02).
          05 WS-CHAR-TMP          PIC X(01).
      *
       PROCEDURE DIVISION.
      *
       REVERSE-STRING.
           COMPUTE WS-STRING-LENGTH =
             FUNCTION LENGTH(FUNCTION TRIM(WS-STRING))
      *
           IF WS-STRING-LENGTH < 1 THEN
             EXIT PARAGRAPH
           END-IF
      *
           MOVE FUNCTION TRIM(WS-STRING) TO WS-STRING
      *
           COMPUTE WS-STRING-STEPS = WS-STRING-LENGTH / 2
      *
           MOVE 1 TO WS-CHAR-IDX-LEFT
           MOVE WS-STRING-LENGTH TO WS-CHAR-IDX-RIGHT
           PERFORM WS-STRING-STEPS TIMES
             MOVE WS-CHAR(WS-CHAR-IDX-LEFT) TO WS-CHAR-TMP
             MOVE WS-CHAR(WS-CHAR-IDX-RIGHT) TO WS-CHAR(WS-CHAR-IDX-LEFT)
             MOVE WS-CHAR-TMP TO WS-CHAR(WS-CHAR-IDX-RIGHT)
             ADD 1 TO WS-CHAR-IDX-LEFT
             SUBTRACT 1 FROM WS-CHAR-IDX-RIGHT
           END-PERFORM.
      *