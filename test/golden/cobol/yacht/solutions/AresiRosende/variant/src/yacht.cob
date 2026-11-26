         IDENTIFICATION DIVISION.
         PROGRAM-ID. YACHT.
         DATA DIVISION.
         WORKING-STORAGE SECTION.
         01 WS-RESULT PIC 99 VALUE 0.
         01 WS-CATEGORY PIC X(15).
         01 WS-DICE PIC 9(5).
         01 FILLER REDEFINES WS-DICE.
            05 D PIC 9 OCCURS 5 TIMES.
         01 WS-DICE-COUNT.
            05 C PIC 9 OCCURS 6 TIMES INDEXED BY I.
         01 AUX1 PIC 99 VALUE 0.
         01 AUX2 PIC 99 VALUE 0.
         PROCEDURE DIVISION.
         YACHT.
            MOVE 0 TO WS-RESULT
            MOVE 0 TO AUX1
            MOVE 0 TO AUX2
            MOVE '000000' TO WS-DICE-COUNT.
            ADD 1 TO C(D(1))
            ADD 1 TO C(D(2))
            ADD 1 TO C(D(3))
            ADD 1 TO C(D(4))
            ADD 1 TO C(D(5))
            EVALUATE WS-CATEGORY
               WHEN 'ones'
                  MOVE C(1) TO WS-RESULT
               WHEN 'twos'
                  COMPUTE WS-RESULT = C(2) * 2
               WHEN 'threes'
                  COMPUTE WS-RESULT = C(3) * 3
               WHEN 'fours' 
                  COMPUTE WS-RESULT = C(4) * 4
               WHEN 'fives' 
                  COMPUTE WS-RESULT = C(5) * 5
               WHEN 'sixes' 
                  COMPUTE WS-RESULT = C(6) * 6
               WHEN 'yacht' 
                  INSPECT WS-DICE TALLYING AUX1 FOR ALL D(1)
                  IF AUX1 = 5 THEN
                     MOVE 50 TO WS-RESULT
               WHEN 'choice'
                  COMPUTE WS-RESULT = D(1) + D(2) + D(3) + D(4) + D(5)
               WHEN 'four of a kind'
                  INSPECT WS-DICE TALLYING AUX1 FOR ALL D(1)
                  IF AUX1 > 3
                     COMPUTE WS-RESULT = 4 * D(1)
                  ELSE
                     INSPECT WS-DICE TALLYING AUX2 FOR ALL D(2)
                     IF AUX2 > 3
                        COMPUTE WS-RESULT = 4 * D(2)
                  END-IF
               WHEN 'full house'
                  SET I TO 1
                  SEARCH C
                     WHEN C(I) = 3
                        COMPUTE AUX1 = 3 * I
                  END-SEARCH
                  SET I TO 1
                  SEARCH C
                     WHEN C(I) = 2
                        COMPUTE AUX2 = 2 * I
                  END-SEARCH
                  IF AUX1 NOT = 0 AND AUX2 NOT = 0 THEN
                     COMPUTE WS-RESULT = AUX1 - AUX2
               WHEN 'little straight'
                  IF WS-DICE-COUNT = '111110' THEN
                     MOVE 30 TO WS-RESULT
               WHEN 'big straight'
                  IF WS-DICE-COUNT = '011111' THEN
                     MOVE 30 TO WS-RESULT
            END-EVALUATE
            CONTINUE.
         YACHT-EXIT.
            EXIT.