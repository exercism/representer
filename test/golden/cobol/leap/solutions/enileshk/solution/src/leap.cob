       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEAP.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
        01 WS-YEAR   PIC X(4).
        01 WS-RESULT PIC 9.
        
       PROCEDURE DIVISION.
       LEAP.
      * Enter solution here
         IF FUNCTION MOD(WS-YEAR,400) = 0
            MOVE 1 TO WS-RESULT
         ELSE
            IF FUNCTION MOD(WS-YEAR,100) = 0 
               MOVE ZERO TO WS-RESULT
            ELSE 
               IF FUNCTION MOD(WS-YEAR,4) = 0
                  MOVE 1 TO WS-RESULT
               ELSE
                  MOVE ZERO TO WS-RESULT
               END-IF
            END-IF
         END-IF
         CONTINUE.
       LEAP-EXIT.
         EXIT.
