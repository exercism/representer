       IDENTIFICATION DIVISION.
       PROGRAM-ID. luhn.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CARD-NUMBER PIC X(32).
       01 WS-CARD-DIGITS PIC 9(32).
       01 WS-CHECKSUM PIC 9(3).
       01 WS-VALID PIC X(5).
       01 WS-LENGTH      PIC 9(02).
       01 WS-I           PIC 9(02).
       01 WS-COUNT       PIC 9(02).
       01 WS-AUX         PIC 9(02).
       01 WS-CHAR        pic 9(02).
       PROCEDURE DIVISION.
       LUHN.
           INITIALIZE WS-I
                      WS-LENGTH
                      WS-AUX
           MOVE 2 TO WS-COUNT
           MOVE 'FALSE' TO WS-VALID
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-CARD-NUMBER))
                TO WS-LENGTH
           IF WS-LENGTH > 1
              MOVE FUNCTION REVERSE(FUNCTION TRIM(WS-CARD-NUMBER) ) 
                   TO WS-CARD-NUMBER
              PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-LENGTH
                 MOVE FUNCTION ORD(WS-CARD-NUMBER(WS-I:1)) TO WS-CHAR
                 
                 IF WS-CHAR >= 48 AND WS-CHAR <= 58 
                    IF WS-I = WS-COUNT
                       MOVE WS-CARD-NUMBER(WS-I:1) TO WS-AUX
                       MULTIPLY 2 BY WS-AUX GIVING WS-AUX
                       IF WS-AUX > 9
                          COMPUTE WS-AUX = WS-AUX - 9
                       END-IF
                       MOVE WS-AUX(2:1) TO WS-CARD-NUMBER(WS-I:1)
                       ADD 2 TO WS-COUNT
                    END-IF
                    MOVE ZEROS TO WS-AUX
                    MOVE WS-CARD-NUMBER(WS-I:1) TO WS-AUX
                    ADD WS-AUX TO WS-CHECKSUM
                 ELSE IF WS-CHAR = 33
                      ADD 1 TO WS-COUNT
                 ELSE
                    MOVE -1 TO WS-CHECKSUM
                    EXIT 
                 END-IF
              END-PERFORM
              IF WS-CHECKSUM >= 0
                 IF FUNCTION MOD (WS-CHECKSUM, 10) = 0
                    MOVE 'VALID' TO WS-VALID
                 END-IF
              END-IF
           END-IF
           .
       

