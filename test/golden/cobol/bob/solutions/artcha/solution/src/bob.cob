       IDENTIFICATION DIVISION.
       PROGRAM-ID. BOB.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-HEYBOB                PIC X(60).
       01 WS-RESULT                PIC X(40).
       01 SPACE-LEN                PIC 9(2).
       01 STR-LEN                  PIC 9(2).
       01 SCREAMING                PIC X VALUE "F".
       01 QUESTION                 PIC X VALUE "F".
       01 FOUND-LETTER          PIC X VALUE "F".
       01 CURRENT-CHAR PIC X.
       01 IDX PIC 9(3) VALUE 0.

       PROCEDURE DIVISION.
       BOB.
           MOVE "F" TO SCREAMING
           MOVE "F" TO QUESTION

           IF WS-HEYBOB = SPACES THEN
               MOVE "Fine. Be that way!" TO WS-RESULT
               EXIT PARAGRAPH
           END-IF

           MOVE 0 TO SPACE-LEN
           INSPECT FUNCTION REVERSE(WS-HEYBOB) TALLYING
               SPACE-LEN FOR LEADING SPACES

           COMPUTE STR-LEN = FUNCTION LENGTH(WS-HEYBOB) - SPACE-LEN
           IF WS-HEYBOB(STR-LEN:1) = "?" THEN
               MOVE "T" TO QUESTION
           END-IF

           MOVE "F" TO FOUND-LETTER

           PERFORM VARYING IDX FROM 1 BY 1 
               UNTIL IDX > LENGTH OF WS-HEYBOB OR FOUND-LETTER = "T"

               MOVE WS-HEYBOB(IDX:1) TO CURRENT-CHAR
               IF (CURRENT-CHAR >= "a" AND CURRENT-CHAR <= "z") OR
                  (CURRENT-CHAR >= "A" AND CURRENT-CHAR <= "Z") THEN
                       MOVE "T" TO FOUND-LETTER
               END-IF
           END-PERFORM

           IF FOUND-LETTER = "T" AND 
               FUNCTION UPPER-CASE(WS-HEYBOB) = WS-HEYBOB THEN

               MOVE "T" TO SCREAMING
           END-IF

           IF QUESTION = "T" AND SCREAMING = "T" THEN
               MOVE "Calm down, I know what I'm doing!" TO WS-RESULT
               EXIT PARAGRAPH
           END-IF

           IF QUESTION = "T" THEN
               MOVE "Sure." TO WS-RESULT
               EXIT PARAGRAPH
           END-IF

           IF SCREAMING = "T" THEN
               MOVE "Whoa, chill out!" TO WS-RESULT
               EXIT PARAGRAPH
           END-IF

           MOVE "Whatever." TO WS-RESULT
       .
