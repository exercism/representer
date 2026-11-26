       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEAP.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 WS-YEAR PIC 9(4).
           01 WS-RESULT PIC 9(4).
           01 WS-REM-4 PIC 9(4).
           01 WS-REM-100 PIC 9(4).
           01 WS-REM-400 PIC 9(4).
       PROCEDURE DIVISION.
       LEAP.
           DIVIDE 4 INTO WS-YEAR GIVING WS-RESULT REMAINDER WS-REM-4.
           DIVIDE 100 INTO WS-YEAR GIVING WS-RESULT REMAINDER WS-REM-100.
           DIVIDE 400 INTO WS-YEAR GIVING WS-RESULT REMAINDER WS-REM-400.
           
           DISPLAY "WS-REM-4" WS-REM-4.
           DISPLAY "WS-REM-100" WS-REM-100.
           DISPLAY "WS-REM-400" WS-REM-400.
           DISPLAY "WS-RESULT" WS-RESULT.
           
           IF WS-REM-4 = 0 THEN
               DISPLAY 'MAYBE A LEAP YEAR...'
               IF WS-REM-100 NOT = 0 THEN
                   DISPLAY 'LEAP YEAR!'
                   MOVE 1 TO WS-RESULT
               ELSE
                   IF WS-REM-400 = 0 THEN
                       DISPLAY 'LEAP YEAR!'
                       MOVE 1 TO WS-RESULT
                   ELSE
                       DISPLAY 'NOT LEAP YEAR!'
                       MOVE 0 TO WS-RESULT
                   END-IF
               END-IF
           ELSE
               DISPLAY 'NOT LEAP YEAR!'
               MOVE 0 TO WS-RESULT
           END-IF  
      * Enter solution here
         CONTINUE.
       LEAP-EXIT.
         EXIT.