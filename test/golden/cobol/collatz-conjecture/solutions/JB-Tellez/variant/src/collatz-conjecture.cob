       IDENTIFICATION DIVISION.
       PROGRAM-ID. collatz-conjecture.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC S9(8).
       01 WS-STEPS PIC 9(4).
       01 WS-ERROR PIC X(35).

       PROCEDURE DIVISION.
       COLLATZ-CONJECTURE.
           PERFORM DO-IT UNTIL WS-NUMBER = 1
           STOP RUN.

       DO-IT.
           IF WS-NUMBER = 1
               EXIT
           END-IF

           IF FUNCTION MOD(WS-NUMBER, 2) = 0
               COMPUTE WS-NUMBER = WS-NUMBER / 2
           ELSE
               COMPUTE WS-NUMBER = WS-NUMBER / 3 + 1
           END-IF

           ADD 1 TO WS-STEPS
           EXIT.
         
      
