       IDENTIFICATION DIVISION.
       PROGRAM-ID. two-fer.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME PIC X(16).
       01 WS-RESULT PIC X(64).
       
       PROCEDURE DIVISION.
       TWO-FER.
           IF WS-NAME NOT = SPACES
              STRING "One for " 
                     FUNCTION TRIM(WS-NAME, TRAILING) 
                     ", one for me."
                     DELIMITED BY SIZE INTO WS-RESULT
           ELSE
              MOVE "One for you, one for me." TO WS-RESULT
           END-IF
           DISPLAY 'Resultado: 'WS-RESULT.
