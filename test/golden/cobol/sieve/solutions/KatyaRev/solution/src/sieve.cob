       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIEVE.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-LIMIT PIC 9999.
       01 WS-RESULT PIC 999 OCCURS 1000 TIMES. 
       01 WS-COUNT PIC 9999.
       01 WS-IDX  PIC 9999.
       01 WS-I    PIC 9999.
       01 WS-PRIME-SW PIC X.
          88 WS-PRIME VALUE 'Y'.
          88 WS-NOT-PRIME VALUE 'N'.
       PROCEDURE DIVISION.
       SIEVE.
          PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 1000
              MOVE 0 TO WS-RESULT(WS-IDX)
          END-PERFORM 
          PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > WS-LIMIT
             IF WS-IDX = 1
                MOVE 0 TO WS-COUNT
             END-IF
             IF WS-IDX = 2
                ADD 1 TO WS-COUNT
                MOVE WS-IDX TO WS-RESULT(WS-COUNT)
             END-IF
             IF WS-IDX > 2
                SET WS-PRIME TO TRUE
                PERFORM VARYING WS-I FROM 1 BY 1 UNTIL 
                  WS-I > WS-COUNT OR WS-NOT-PRIME 
                  IF MOD(WS-IDX,WS-RESULT(WS-I)) = 0
                     SET WS-NOT-PRIME TO TRUE
                  END-IF
                END-PERFORM
                IF WS-PRIME 
                   ADD 1 TO WS-COUNT
                   MOVE WS-IDX TO WS-RESULT(WS-COUNT)
                END-IF
             END-IF
          END-PERFORM.
                     
                
                
                