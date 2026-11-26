       IDENTIFICATION DIVISION.
       PROGRAM-ID. GRADE-SCHOOL.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-STUDENTNAME           PIC X(60).
       01 WS-STUDENTGRADE          PIC 9.
       01 WS-DESIREDGRADE          PIC 9.
       01 WS-RESULT                PIC X(5).
       
       01 STUDENTROSTER.
           02 ROSTER               OCCURS 10 TIMES
                                   INDEXED BY ROSTER-IDX.
              05 ST-NAME           PIC X(60).
              05 ST-GRADE          PIC 9.   

       01 WS-I                     PIC 9(2).
       01 WS-J                     PIC 9(2).
      
       PROCEDURE DIVISION.
        
       INIT-ROSTER.
         PERFORM VARYING ROSTER-IDX FROM 1 BY 1 UNTIL ROSTER-IDX > 10
            MOVE SPACES TO ST-NAME(ROSTER-IDX)
            MOVE 0      TO ST-GRADE(ROSTER-IDX)
         END-PERFORM
         .

       ADD-STUDENT.
         SET ROSTER-IDX TO 1
         SEARCH ROSTER
            WHEN ST-NAME(ROSTER-IDX) = WS-STUDENTNAME
               EXIT PARAGRAPH
         END-SEARCH

         SET ROSTER-IDX TO 1
         SEARCH ROSTER
            WHEN ST-NAME(ROSTER-IDX) = SPACES
               MOVE WS-STUDENTNAME TO ST-NAME(ROSTER-IDX)
               MOVE WS-STUDENTGRADE TO ST-GRADE(ROSTER-IDX)
         END-SEARCH
         SORT ROSTER
              ON ASCENDING KEY ST-GRADE
              ON ASCENDING KEY ST-NAME

         MOVE 0 TO WS-J
         PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
            IF ST-NAME(WS-I) NOT = SPACES
               ADD 1 TO WS-J
               IF WS-I NOT = WS-J
                  MOVE ST-NAME(WS-I)  TO ST-NAME(WS-J)
                  MOVE ST-GRADE(WS-I) TO ST-GRADE(WS-J)
               END-IF
            END-IF
         END-PERFORM

         ADD 1 TO WS-J
         PERFORM VARYING WS-I FROM WS-J BY 1 UNTIL WS-I > 10
            MOVE SPACES TO ST-NAME(WS-I)
            MOVE 0      TO ST-GRADE(WS-I)
         END-PERFORM
         .


       GET-GRADE.
         MOVE 0 TO WS-J
         PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
            IF ST-GRADE(WS-I) = WS-DESIREDGRADE
               ADD 1 TO WS-J
               IF WS-I NOT = WS-J
                  MOVE ST-NAME(WS-I) TO ST-NAME(WS-J)
                  MOVE ST-GRADE(WS-I) TO ST-GRADE(WS-J)
               END-IF
            END-IF
         END-PERFORM

         ADD 1 TO WS-J
         PERFORM VARYING WS-I FROM WS-J BY 1 UNTIL WS-I >= 10
            MOVE SPACES TO ST-NAME(WS-I)
            MOVE 0      TO ST-GRADE(WS-I)
         END-PERFORM
         .
       