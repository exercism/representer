       IDENTIFICATION DIVISION.
       PROGRAM-ID. PASCALS-TRIANGLE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-COUNT PIC 99.
       01 WS-INDEX PIC 99.
       01 WS-INP-INDEX PIC 99.
       01 TEMP-A PIC 999.
       01 TEMP-B PIC 999.
       01 WS-CURRENT PIC X(60).
       01 WS-CUR-ROW PIC X(60).
       01 TRAIL PIC 9.
       
       01 WS-RESULT. 
         02 WS-ROW               OCCURS 1 TO 99 DEPENDING ON WS-COUNT.
            05 ROWELEM           PIC X(60).
       
       PROCEDURE DIVISION.
       
       ROWS.
         MOVE 0 TO WS-INDEX
         IF WS-COUNT NOT = 0
            PERFORM VARYING WS-INDEX 
               FROM 1 BY 1 UNTIL WS-INDEX = WS-COUNT + 1
               IF WS-INDEX = 1
                  MOVE "1" TO WS-ROW(1)
               ELSE
                  IF WS-INDEX = 2
                     MOVE "1,1" TO WS-ROW(2)
                  ELSE
                     MOVE 0 TO WS-INP-INDEX 
                     MOVE WS-ROW(WS-INDEX + 1) TO WS-CUR-ROW
                     INSPECT WS-CUR-ROW REPLACING FIRST ',' BY '\'   
                     UNSTRING WS-CUR-ROW DELIMITED BY '\' 
                        INTO TEMP-A WS-CUR-ROW
                     MOVE TEMP-A(3:) TO WS-CURRENT
                     PERFORM VARYING WS-INP-INDEX 
                        FROM 1 BY 1 UNTIL WS-INP-INDEX = WS-INDEX - 1
                        INSPECT WS-CUR-ROW REPLACING FIRST ',' BY '\'   
                        UNSTRING WS-CUR-ROW DELIMITED BY '\' 
                           INTO TEMP-B WS-CUR-ROW       
                        END-UNSTRING
                        COMPUTE TEMP-A = FUNCTION NUMVAL(TEMP-A)
                           + FUNCTION NUMVAL(TEMP-B)
                        MOVE 0 TO TRAIL
                        INSPECT TEMP-A TALLYING TRAIL FOR LEADING ZEROS
                        ADD 1 TO TRAIL
                        STRING WS-CURRENT DELIMITED BY SPACES
                           "," DELIMITED BY SIZE
                           TEMP-A(TRAIL:)
                           INTO WS-CURRENT
                        MOVE TEMP-B TO TEMP-A
                        IF FUNCTION NUMVAL(TEMP-A) = 1
                           STRING WS-CURRENT DELIMITED BY SPACES
                           "," DELIMITED BY SIZE
                           TEMP-A(TRAIL:) DELIMITED BY SPACES
                           INTO WS-CURRENT
                        END-IF
                     END-PERFORM
                     MOVE WS-CURRENT TO WS-ROW(WS-INDEX)
                  END-IF
               END-IF
            END-PERFORM
         END-IF.
        
