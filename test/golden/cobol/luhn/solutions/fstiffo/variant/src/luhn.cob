       IDENTIFICATION DIVISION.
       PROGRAM-ID. luhn.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CARD-NUMBER PIC X(64).
       01 WS-CARD-DIGITS PIC 99.
       01 WS-CHECKSUM PIC 9(4).
       01 WS-VALID PIC X(5).
       01 WS-NUM PIC X(64).
       01 WS-IDX PIC 99.
       01 WS-CHAR PIC X.
       01 WS-DIGIT PIC 99.
       01 WS-DBL PIC 9.
       01 WS-BAD PIC 9.
       
       PROCEDURE DIVISION.
       LUHN.
           MOVE "FALSE" TO WS-VALID
           MOVE 0 TO WS-CARD-DIGITS
           MOVE 0 TO WS-CHECKSUM
           MOVE WS-CARD-NUMBER TO WS-NUM
           MOVE 0 TO WS-DBL
           MOVE 0 TO WS-BAD

           PERFORM VARYING WS-IDX FROM 64 BY -1 UNTIL WS-IDX < 1
              IF WS-BAD = 0
                 MOVE WS-NUM(WS-IDX:1) TO WS-CHAR

                 IF WS-CHAR = SPACE
                    CONTINUE
                 ELSE
                    IF WS-CHAR IS NUMERIC
                    MOVE WS-CHAR TO WS-DIGIT

                    IF WS-DBL = 1
                       MULTIPLY 2 BY WS-DIGIT
                       IF WS-DIGIT > 9
                          SUBTRACT 9 FROM WS-DIGIT
                       END-IF
                    END-IF

                    ADD WS-DIGIT TO WS-CHECKSUM
                    ADD 1 TO WS-CARD-DIGITS

                    IF WS-DBL = 1
                       MOVE 0 TO WS-DBL
                    ELSE
                       MOVE 1 TO WS-DBL
                    END-IF
                 ELSE
                    MOVE 1 TO WS-BAD
                 END-IF
              END-IF
              END-IF
              END-PERFORM

           IF WS-BAD = 0
              IF WS-CARD-DIGITS >= 1
                 IF FUNCTION MOD(WS-CHECKSUM 10) = 0
                    MOVE "VALID" TO WS-VALID
                 END-IF
              END-IF
           END-IF.

