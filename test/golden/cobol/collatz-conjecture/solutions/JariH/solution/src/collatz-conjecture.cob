       IDENTIFICATION DIVISION.
       PROGRAM-ID. collatz-conjecture.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC S9(8).
       01 WS-STEPS PIC 9(4).
       01 WS-ERROR PIC X(35).

       PROCEDURE DIVISION.
       COLLATZ-CONJECTURE.
         move zeroes to WS-STEPS
         if WS-NUMBER <= 0
            move "Only positive integers are allowed" to WS-ERROR
         end-if
         perform varying WS-STEPS FROM 0 by 1 until WS-NUMBER <= 1
            IF FUNCTION MOD(WS-NUMBER,2) = 0 THEN 
              COMPUTE WS-NUMBER = WS-NUMBER / 2
            ELSE
              COMPUTE WS-NUMBER = (WS-NUMBER * 3) + 1
            END-IF 
         end-perform

       DISPLAY WS-STEPS.
       DISPLAY WS-ERROR.
