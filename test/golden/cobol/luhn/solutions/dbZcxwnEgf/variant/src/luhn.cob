       IDENTIFICATION DIVISION.
       PROGRAM-ID. luhn.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CARD-NUMBER PIC X(32).
       01 WS-CARD-DIGITS PIC 9(32).
       01 WS-DIGIT PIC 9(2).
       01 WS-CHECKSUM PIC 9(2).
       01 I PIC 9(2).
       01 WS-VALID PIC X(5).
       
       PROCEDURE DIVISION.
       LUHN.

       MOVE "FALSE" TO WS-VALID

      *Very short numbers are invalid
       IF FUNCTION LENGTH(FUNCTION TRIM(WS-CARD-NUMBER)) <= 1
          EXIT PARAGRAPH
       END-IF

      *Characters other than digits and space invalidate the number
       PERFORM VARYING I FROM 1 BY 1 UNTIL I >= 32
         IF WS-CARD-NUMBER(I:1) IS NOT NUMERIC AND WS-CARD-NUMBER(I:1) <> SPACE
            EXIT PARAGRAPH
         END-IF
       END-PERFORM

      *Calculate checksum from numeric
       MOVE WS-CARD-NUMBER TO WS-CARD-DIGITS
       MOVE 0 TO WS-CHECKSUM
       PERFORM VARYING I FROM 1 BY 1 UNTIL WS-CARD-DIGITS = 0
          MOVE FUNCTION MOD(WS-CARD-DIGITS, 10) TO WS-DIGIT
          IF FUNCTION MOD(I, 2) = 0
             MULTIPLY WS-DIGIT BY 2 GIVING WS-DIGIT
             IF WS-DIGIT > 9
                SUBTRACT 9 FROM WS-DIGIT
             END-IF
          END-IF
          ADD WS-DIGIT TO WS-CHECKSUM
          DIVIDE WS-CARD-DIGITS BY 10 GIVING WS-CARD-DIGITS
       END-PERFORM

      *Check validity of checksum
       IF FUNCTION MOD(WS-CHECKSUM, 10) = 0
          MOVE "VALID" TO WS-VALID
       END-IF
       .
