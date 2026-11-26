       IDENTIFICATION DIVISION.
       PROGRAM-ID. DIAMOND.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-INPUTVARS. 
           05 WS-LETTER            PIC X.
           05 WS-ROWS              PIC 99.
       01 WS-OUTPUTTABLE.
           05 WS-TABLEROW    OCCURS 1 TO 60 DEPENDING ON WS-ROWS.
              10 WS-LINE           PIC X(60).
       01 WS-LIST                  PIC X(26)
                     VALUE       "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       01 WS-IDX                   PIC 99.
       01 WS-LET                   PIC 99.
       01 WS-L                     PIC 99.
       01 WS-ID                    PIC 99.

       PROCEDURE DIVISION.
       
       DIAMOND. 

         MOVE 0 TO WS-ROWS.
         PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-ROWS > 0
            IF WS-LETTER = WS-LIST(WS-IDX:1)
               COMPUTE WS-ROWS = WS-IDX * 2 - 1
               MOVE WS-IDX TO WS-LET
            END-IF   
         END-PERFORM.
         PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > WS-ROWS
             MOVE SPACE TO WS-LINE(WS-IDX)
         END-PERFORM.
         
         PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > WS-ROWS
          PERFORM VARYING WS-ID FROM 1 BY 1 UNTIL WS-ID > WS-ROWS
           PERFORM VARYING WS-L FROM 1 BY 1 UNTIL WS-L > WS-LET 
            IF WS-IDX = WS-L AND WS-ID = WS-LET - WS-L + 1
            OR WS-IDX = WS-ROWS + WS-L + 1 AND WS-ID = WS-LET - WS-L + 1
            OR WS-IDX = WS-L AND WS-ID = WS-LET + WS-L - 1
            OR WS-IDX = WS-ROWS - WS-L + 1 AND WS-ID = WS-LET + WS-L - 1
                   MOVE WS-LIST(WS-L:1) TO WS-LINE(WS-IDX)(WS-ID:1)
            END-IF
           END-PERFORM
         END-PERFORM 
        END-PERFORM.