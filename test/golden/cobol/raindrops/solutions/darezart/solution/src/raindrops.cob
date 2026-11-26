       IDENTIFICATION DIVISION.
       PROGRAM-ID. raindrops.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC 9(4).
       01 WS-RESULT PIC X(20).
       PROCEDURE DIVISION.
       RAINDROPS.
           IF ((FUNCTION MOD(WS-NUMBER, 3) = 0) OR 
               (FUNCTION MOD(WS-NUMBER, 5) = 0) OR 
               (FUNCTION MOD(WS-NUMBER, 7) = 0))
              IF FUNCTION MOD(WS-NUMBER, 3) = 0
                 MOVE 'Pling' TO WS-RESULT
              END-IF
              IF FUNCTION MOD(WS-NUMBER, 5) = 0
                 STRING WS-RESULT
                        DELIMITED BY ''
                        'Plang'
                        DELIMITED BY SIZE
                        INTO WS-RESULT
              END-IF
              IF FUNCTION MOD(WS-NUMBER, 7) = 0
                 STRING WS-RESULT
                        DELIMITED BY ''
                        'Plong'
                        DELIMITED BY SIZE
                        INTO WS-RESULT
              END-IF
           ELSE
              MOVE WS-NUMBER TO WS-RESULT 
           END-IF
           DISPLAY 'Resultado: 'WS-RESULT.
           

