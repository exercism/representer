       IDENTIFICATION DIVISION.
       PROGRAM-ID. acronym.
       ENVIRONMENT DIVISION.
       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-ACRONYM               PIC X(80).
       01 WS-RESULT                PIC X(20).
       01 WS-F                     PIC X(1).
          88 WS-FLAG               VALUE 'Y'.
          88 WS-FLAG-NO            VALUE 'N'.
       01 WS-I                     PIC 99.
       01 WS-TEMP                  PIC X(1).
       01 WS-OUT                   PIC 99.

       PROCEDURE DIVISION.
       ABBREVIATE.
        SET WS-FLAG TO TRUE
        MOVE ZERO   TO WS-OUT
                MOVE SPACES TO WS-RESULT

        PERFORM VARYING WS-I FROM 1 BY 1 UNTIL
                        WS-I >80
          MOVE WS-ACRONYM(WS-I:1) TO WS-TEMP
          IF WS-TEMP EQUAL TO SPACES OR
              WS-TEMP EQUAL TO "-" OR "_"
              SET WS-FLAG TO TRUE
          ELSE 
              IF WS-FLAG 
                 ADD 1 TO WS-OUT
                 MOVE WS-TEMP TO WS-RESULT(WS-OUT:1)
                 SET WS-FLAG-NO TO TRUE
              END-IF
         END-IF
         MOVE FUNCTION UPPER-CASE(WS-RESULT) TO WS-RESULT
         END-PERFORM.
