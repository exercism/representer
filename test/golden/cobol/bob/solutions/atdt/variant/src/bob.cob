       PROGRAM-ID. BOB.
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
       01 WS-HEYBOB                PIC X(60).
       01 WS-RESULT                PIC X(40).
      *
       LOCAL-STORAGE SECTION.
       01 LEN PIC 9(2).
       01 I PIC 9(2).
       01 HAS-UPPER PIC 9.
       01 HAS-LOWER PIC 9.
      *
       PROCEDURE DIVISION.
      *
       BOB.
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-HEYBOB)) TO LEN.
           MOVE 0 TO HAS-UPPER.
           MOVE 0 TO HAS-LOWER.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I >= LEN
               EVALUATE WS-HEYBOB(I:1)
                   WHEN 'A' THRU 'Z' MOVE 1 TO HAS-UPPER
                   WHEN 'a' THRU 'z' MOVE 1 TO HAS-LOWER
               END-EVALUATE
           END-PERFORM.

           EVALUATE TRUE
           WHEN LEN = 0
               MOVE "Fine. Be that way!" TO WS-RESULT
           WHEN WS-HEYBOB(LEN:1) = "?"
               IF HAS-UPPER = 1 AND HAS-LOWER = 0
                   MOVE "Calm down, I know what I'm doing!" TO WS-RESULT
               ELSE
                   MOVE "Sure." TO WS-RESULT
               END-IF
           WHEN HAS-UPPER = 1 AND HAS-LOWER = 0
               MOVE "Whoa, chill out!" TO WS-RESULT
           WHEN OTHER
               MOVE "Whatever." TO WS-RESULT
           END-EVALUATE
           .
      *
       BOB-EXIT.
           EXIT.
