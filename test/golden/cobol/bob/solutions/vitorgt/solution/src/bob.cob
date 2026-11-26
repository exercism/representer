       IDENTIFICATION DIVISION.
       PROGRAM-ID. BOB.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.

       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01 WS-HEYBOB PIC X(60).
       01 WS-RESULT PIC X(40).

       PROCEDURE DIVISION.

       BOB.
           EVALUATE TRUE
           WHEN WS-HEYBOB = SPACE OR LOW-VALUE
            MOVE "Fine. Be that way!" TO WS-RESULT
           WHEN UPPER-CASE(WS-HEYBOB) = WS-HEYBOB AND
           NOT LOWER-CASE(WS-HEYBOB) = WS-HEYBOB
            IF REVERSE(TRIM(WS-HEYBOB))(1:1) = "?"
             MOVE "Calm down, I know what I'm doing!" TO WS-RESULT
            ELSE
             MOVE "Whoa, chill out!" TO WS-RESULT
            END-IF
           WHEN REVERSE(TRIM(WS-HEYBOB))(1:1) = "?"
             MOVE "Sure." TO WS-RESULT
           WHEN OTHER
             MOVE "Whatever." TO WS-RESULT
           END-EVALUATE.
       BOB-EXIT.

       9999-STOP-RUN.
           STOP RUN.

       END PROGRAM BOB.
