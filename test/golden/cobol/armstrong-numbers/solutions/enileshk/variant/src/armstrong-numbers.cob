       IDENTIFICATION DIVISION.
       PROGRAM-ID. armstrong-numbers.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC X(8).
       01 WS-RESULT PIC 9.
       01 WS-LEN    PIC 9.
       01 WS-SUM    PIC 9(12).
       01 WS-RES    PIC 9(12).

       01 WS-TEMP   PIC 9(8).
       01 WS-CURR   PIC 9.
       01 WS-I      PIC 9.
       01 WS-IN     PIC x(8).

       PROCEDURE DIVISION.
       ARMSTRONG-NUMBERS.
          MOVE WS-NUMBER TO WS-IN
          MOVE ZERO TO WS-LEN
          MOVE 1 TO WS-I
          
          PERFORM 8 TIMES
             IF WS-IN(WS-I:2) IS NUMERIC
                ADD 1 TO WS-LEN
             END-IF
             ADD 1 TO WS-I
          END-PERFORM
          MOVE ZERO TO WS-SUM
          MOVE ZERO TO WS-I  
          PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I>WS-LEN
             IF WS-IN(WS-I:1) IS NUMERIC
             MOVE WS-IN(WS-I:1) TO WS-CURR
             DISPLAY "cur:" WS-CURR 
             COMPUTE WS-TEMP = WS-CURR**WS-LEN
             DISPLAY "TMP:" WS-TEMP
             ADD WS-TEMP TO WS-SUM
            END-IF
          END-PERFORM
          DISPLAY WS-SUM
          MOVE WS-IN TO WS-RES
          IF WS-SUM = WS-RES OR WS-LEN = 1 OR WS-IN = 0
             MOVE 1 TO WS-RESULT
          ELSE
             MOVE ZERO TO WS-RESULT
          END-IF.
        