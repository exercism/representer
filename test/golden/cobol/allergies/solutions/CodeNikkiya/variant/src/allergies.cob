       IDENTIFICATION DIVISION.
       PROGRAM-ID. allergies.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-SCORE       PIC 999.
       01 WS-ITEM        PIC X(12).
       01 WS-RESULT      PIC A.
       01 WS-RESULT-LIST PIC X(108).
       01 WS-RES-ITER    PIC 999.
       01 WS-COPY-ITER   PIC 99.
       01 WS-ITEM-TO-ADD PIC X(64).
       01 WS-SCORE-TEMP  PIC 999.
      

       PROCEDURE DIVISION.
       ALLERGIC-TO.
       MOVE WS-SCORE TO WS-SCORE-TEMP
       MOVE "N" TO WS-RESULT
       IF WS-ITEM = "eggs"
           IF FUNCTION MOD (WS-SCORE-TEMP, 2) >= 1
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "peanuts "
           IF FUNCTION MOD (WS-SCORE-TEMP, 4) >= 2
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "shellfish "
           IF FUNCTION MOD (WS-SCORE-TEMP, 8) >= 4
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "strawberries "
           IF FUNCTION MOD (WS-SCORE-TEMP, 16) >= 8
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "tomatoes  "
           IF FUNCTION MOD (WS-SCORE-TEMP, 32) >= 16
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "chocolate "
           IF FUNCTION MOD (WS-SCORE-TEMP, 64) >= 32
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "pollen "
           IF FUNCTION MOD (WS-SCORE-TEMP, 128) >= 64
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
       IF WS-ITEM = "cats "
           IF FUNCTION MOD (WS-SCORE-TEMP, 256) >= 128
               MOVE "Y" TO WS-RESULT
           ELSE
               MOVE "N" TO WS-RESULT
       END-IF.
           CONTINUE.

       LIST-ALLERGENS.
       MOVE "" TO WS-RESULT-LIST
       MOVE WS-SCORE TO WS-SCORE-TEMP
       MOVE 1 TO WS-COPY-ITER
       MOVE 1 TO WS-RES-ITER
       IF FUNCTION MOD (WS-SCORE-TEMP, 2) >= 1
           ADD -1 TO WS-SCORE-TEMP
           MOVE "eggs" TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 4) >= 2
           ADD -2 TO WS-SCORE-TEMP
           MOVE "peanuts" TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 8) >= 4
           ADD -4 TO WS-SCORE-TEMP
           MOVE "shellfish " TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 16) >= 8
           ADD -8 TO WS-SCORE-TEMP
           MOVE "strawberries   " TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 32) >= 16
           ADD -16 TO WS-SCORE-TEMP
           MOVE "tomatoes" TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 64) >= 32
           ADD -32 TO WS-SCORE-TEMP
           MOVE "chocolate" TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 128) > 64
           ADD -64 TO WS-SCORE-TEMP
           MOVE "pollen" TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       IF FUNCTION MOD (WS-SCORE-TEMP, 256) >= 128
           ADD -128 TO WS-SCORE-TEMP
           MOVE "cats" TO WS-ITEM-TO-ADD
           PERFORM APPEND-STRING
       END-IF.
       
           CONTINUE.
       APPEND-STRING.
       IF WS-RESULT-LIST (1:1) NOT = " "
          MOVE "," to WS-RESULT-LIST (WS-RES-ITER:1)
          ADD 1 TO WS-RES-ITER
       END-IF.
       PERFORM UNTIL WS-ITEM-TO-ADD(WS-COPY-ITER:1) = " "
          MOVE WS-ITEM-TO-ADD(WS-COPY-ITER:1)
            TO WS-RESULT-LIST (WS-RES-ITER:1)
          ADD 1 TO WS-RES-ITER     
          ADD 1 TO WS-COPY-ITER          
       END-PERFORM.
       MOVE 1 TO WS-COPY-ITER
       EXIT.
