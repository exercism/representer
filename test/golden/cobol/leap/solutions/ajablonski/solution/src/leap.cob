       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEAP.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 WS-YEAR PIC 9(4) PACKED-DECIMAL.
           01 WS-RESULT PIC 9 PACKED-DECIMAL.
       PROCEDURE DIVISION.
           LEAP.
               IF FUNCTION MOD(WS-YEAR, 4) IS NOT = 0 
                   OR (FUNCTION MOD(WS-YEAR, 100) IS = 0 
                     AND FUNCTION MOD(WS-YEAR, 400) IS NOT = 0) 
               THEN
                   MOVE 0 TO WS-RESULT
               ELSE
                   MOVE 1 TO WS-RESULT
               END-IF
           
               CONTINUE.
           LEAP-EXIT.
               EXIT.
       