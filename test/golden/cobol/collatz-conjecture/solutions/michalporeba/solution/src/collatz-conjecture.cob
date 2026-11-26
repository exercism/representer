       IDENTIFICATION DIVISION.
       PROGRAM-ID. collatz-conjecture.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER     PIC S9(8).
       01 WS-STEPS      PIC 9(4).
       01 WS-ERROR      PIC X(35).

       PROCEDURE DIVISION.
       COLLATZ-CONJECTURE.

       PERFORM UNTIL WS-NUMBER = 1
         IF 0 = FUNCTION MOD(WS-NUMBER, 2) THEN
           COMPUTE WS-NUMBER = WS-NUMBER / 2
         ELSE 
           COMPUTE WS-NUMBER = 3 * WS-NUMBER + 1
         END-IF
         ADD 1 TO WS-STEPS
         GOBACK
       END-PERFORM.
       END-RUN.

      