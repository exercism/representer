       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEAP.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 WS-YEAR       PIC 9999 VALUE ZEROES.
       77 WS-DIV        PIC 9999 VALUE 0.
       77 WS-REM        PIC 999  VALUE 0.
       77 WS-RESULT     PIC 9.

       PROCEDURE DIVISION.
       LEAP.
           DIVIDE WS-YEAR BY 4 GIVING WS-DIV REMAINDER WS-REM.
           IF WS-REM NOT = 0 THEN
              MOVE 0 TO WS-RESULT

           ELSE
              DIVIDE WS-YEAR BY 100 GIVING WS-DIV REMAINDER WS-REM
              IF WS-REM NOT = 0 THEN
                 MOVE 1 TO WS-RESULT

              ELSE
                 DIVIDE WS-YEAR BY 400 GIVING WS-DIV REMAINDER WS-REM
                 IF WS-REM NOT = 0 THEN
                    MOVE 0 TO WS-RESULT

                 ELSE
                    MOVE 1 TO WS-RESULT
                 END-IF
              END-IF
           END-IF.

           CONTINUE.
       LEAP-EXIT.
           EXIT.
