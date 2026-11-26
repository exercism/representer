        IDENTIFICATION DIVISION.
        PROGRAM-ID. PANGRAM.
        ENVIRONMENT DIVISION.
        DATA DIVISION.
        WORKING-STORAGE SECTION.
       01 WS-SENTENCE                 PIC X(60) VALUE SPACES.
       01 WS-RESULT                   PIC 9.

       01 WS-COMPARABLE-SENTENCE      PIC X(60) VALUE SPACES.
       01 WS-COMPARABLE-SENTENCE-SUB  PIC 99    VALUE ZEROS.
       01 WS-INITIAL-ORD              PIC 9(3).
       01 WS-ALPHABET-SUB             PIC 99.
       01 WS-ALPHABET-CI              PIC X(26) VALUE SPACES.
       01 COUNTER                     PIC 99    VALUE ZERO.

        PROCEDURE DIVISION.
       PANGRAM.
           PERFORM INITIALIZE-ALPHABET.
           PERFORM COMPARE-SOURCE.

       INITIALIZE-ALPHABET.
      * consists of letters latin a-z, case insensative
           COMPUTE WS-INITIAL-ORD = FUNCTION ORD('a').
           PERFORM VARYING WS-ALPHABET-SUB
              FROM 1 BY 1
              UNTIL WS-ALPHABET-SUB > 26
                   MOVE FUNCTION CHAR(WS-INITIAL-ORD +
                      WS-ALPHABET-SUB - 1) TO
                      WS-ALPHABET-CI(WS-ALPHABET-SUB:1)
           END-PERFORM.

       COMPARE-SOURCE.
           MOVE SPACES TO WS-COMPARABLE-SENTENCE.
           MOVE FUNCTION LOWER-CASE(WS-SENTENCE) TO
              WS-COMPARABLE-SENTENCE.
           PERFORM VARYING WS-COMPARABLE-SENTENCE-SUB
              FROM 1 BY 1
              UNTIL WS-COMPARABLE-SENTENCE-SUB > 60
                   INSPECT WS-ALPHABET-CI
                      REPLACING ALL WS-COMPARABLE-SENTENCE
                      (WS-COMPARABLE-SENTENCE-SUB:1)
                      BY SPACE
           END-PERFORM.
           MOVE 0 TO COUNTER
           INSPECT WS-ALPHABET-CI TALLYING COUNTER FOR ALL SPACES.

           IF COUNTER = 26 THEN
              MOVE 1 TO WS-RESULT
           ELSE
              MOVE 0 TO WS-RESULT
           END-IF.