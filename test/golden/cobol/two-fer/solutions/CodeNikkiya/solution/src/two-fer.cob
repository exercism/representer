       IDENTIFICATION DIVISION.
       PROGRAM-ID. two-fer.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME PIC X(16).
       01 WS-RESULT PIC X(64).
       01 WS-COUNT PIC 9(2).
       01 WS-CALL PIC X(16).
       
       PROCEDURE DIVISION.
       TWO-FER.
       MOVE 1 to WS-COUNT

       IF WS-NAME  =  SPACES
          MOVE "you" to WS-CALL 
       ELSE
          MOVE WS-NAME to WS-CALL 
       END-IF
      
       STRING
       "One for " DELIMITED BY SIZE
       WS-CALL    DELIMITED BY SPACE
       ", one for me." DELIMITED BY SIZE
       INTO WS-RESULT
       
       EXIT.
