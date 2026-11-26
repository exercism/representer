       IDENTIFICATION DIVISION.
       PROGRAM-ID. BOB.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-HEYBOB                PIC X(60).
       01 WS-RESULT                PIC X(40).
       PROCEDURE DIVISION.
       BOB.
         EVALUATE TRUE
         WHEN WS-HEYBOB = SPACE OR LOW-VALUE
            MOVE "Fine. Be that way!" TO WS-RESULT
         WHEN FUNCTION UPPER-CASE(WS-HEYBOB) = WS-HEYBOB AND NOT FUNCTION LOWER-CASE(WS-HEYBOB) = WS-HEYBOB
               IF FUNCTION REVERSE(FUNCTION TRIM(WS-HEYBOB)) (1:1) = "?"
                  MOVE "Calm down, I know what I'm doing!" TO WS-RESULT
               ELSE
                  MOVE "Whoa, chill out!" TO WS-RESULT
         WHEN FUNCTION REVERSE(FUNCTION TRIM(WS-HEYBOB))(1:1) = "?"
            MOVE "Sure." TO WS-RESULT
         WHEN OTHER
            MOVE "Whatever." TO WS-RESULT
         END-EVALUATE.