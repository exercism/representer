       IDENTIFICATION DIVISION.
       PROGRAM-ID. two-fer.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME    PIC X(16).
       01 WS-RESULT  PIC X(65).
       
       PROCEDURE DIVISION.
       TWO-FER.

           IF FUNCTION LENGTH(FUNCTION TRIM(WS-NAME)) > 0
               STRING "One for " DELIMITED BY SIZE
                      WS-NAME   DELIMITED BY SPACE
                      ", one for me." DELIMITED BY SIZE
                      INTO WS-RESULT
           ELSE
               MOVE "One for you, one for me." TO WS-RESULT
           END-IF.
