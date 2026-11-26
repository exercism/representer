        IDENTIFICATION DIVISION.
        PROGRAM-ID. PANGRAM.
        ENVIRONMENT DIVISION.
        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 WS-SENTENCE      PIC X(60).
       01 WS-RESULT        PIC 9 VALUE 0.

       01 WS-ALPHABET      PIC X(26)
           VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".

       01 WS-I             PIC 9(02).
       01 WS-J             PIC 9(02).
       01 WS-FOUND         PIC 9.
       01 WS-CHAR          PIC X.
        PROCEDURE DIVISION.
        PANGRAM.
         
           MOVE FUNCTION UPPER-CASE(WS-SENTENCE)
             TO WS-SENTENCE

           MOVE 1 TO WS-RESULT

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 26

               MOVE 0 TO WS-FOUND

               PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > 60

                   MOVE WS-SENTENCE(WS-J:1) TO WS-CHAR

                   IF WS-CHAR = WS-ALPHABET(WS-I:1)
                       MOVE 1 TO WS-FOUND
                   END-IF

               END-PERFORM

               IF WS-FOUND = 0
                   MOVE 0 TO WS-RESULT
                   EXIT PERFORM
               END-IF

           END-PERFORM
