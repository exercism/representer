       IDENTIFICATION DIVISION.
       PROGRAM-ID. SCRABBLE-SCORE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *Inputs
       01 WS-WORD               PIC X(60).

      *Outputs
       01 WS-RESULT             PIC 99 VALUE 0.

      *Variables
       01 WS-LEN                PIC 99 VALUE 0.
       01 WS-IX                 PIC 99 VALUE 0.
      
       01 WS-LETTERSET          PIC X.
          88 WS-LETTERSET-1     VALUE "A" "E" "I" "O" "U" 
                                          "L" "N" "R" "S" "T".
          88 WS-LETTERSET-2     VALUE "D" "G".
          88 WS-LETTERSET-3     VALUE "B" "C" "M" "P".
          88 WS-LETTERSET-4     VALUE "F" "H" "V" "W" "Y".
          88 WS-LETTERSET-5     VALUE "K".
          88 WS-LETTERSET-6     VALUE "J" "X".
          88 WS-LETTERSET-7     VALUE "Q" "Z".
      
       PROCEDURE DIVISION.
       SCRABBLE-SCORE.
         MOVE 0 TO WS-RESULT
         MOVE FUNCTION UPPER-CASE(WS-WORD) TO WS-WORD 
         COMPUTE WS-LEN = FUNCTION LENGTH(FUNCTION TRIM(WS-WORD))
         PERFORM VARYING WS-IX FROM 1 BY 1 UNTIL WS-IX > WS-LEN
            MOVE WS-WORD(WS-IX:1) TO WS-LETTERSET
            PERFORM INCREMENT-SCORE
         END-PERFORM.

       INCREMENT-SCORE.
         EVALUATE TRUE
            WHEN WS-LETTERSET-1 ADD 1 TO WS-RESULT
            WHEN WS-LETTERSET-2 ADD 2 TO WS-RESULT
            WHEN WS-LETTERSET-3 ADD 3 TO WS-RESULT
            WHEN WS-LETTERSET-4 ADD 4 TO WS-RESULT
            WHEN WS-LETTERSET-5 ADD 5 TO WS-RESULT
            WHEN WS-LETTERSET-6 ADD 8 TO WS-RESULT
            WHEN WS-LETTERSET-7 ADD 10 TO WS-RESULT
         END-EVALUATE.