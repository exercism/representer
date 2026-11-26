       IDENTIFICATION DIVISION.
       PROGRAM-ID. YACHT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RESULT PIC 99 VALUE 0.
       01 WS-CATEGORY PIC X(15).
       01 WS-DICE.
         02 WS-DIE PIC 9 OCCURS 5 TIMES.
       01 WS-I PIC 9.
       01 WS-TARGET PIC 9.
       01 WS-COUNT PIC 9.
       01 WS-IS-FULL-HOUSE PIC 9.
       01 WS-IS-FOUR-OF-A-KIND PIC 9.
       01 WS-IS-STRAIGHT PIC 9.
       01 WS-IS-YACHT PIC 9.
       01 WS-IS-PAIR-PRESENT PIC 9.
       01 WS-IS-TRIS-PRESENT PIC 9.
       01 WS-COUNT-ARRAY.
         02 WS-COUNT-ELEMENT PIC 9 OCCURS 6 TIMES.
          PROCEDURE DIVISION.
          YACHT.
            MOVE 0 TO WS-RESULT.
            EVALUATE WS-CATEGORY
               WHEN "ones"
                  MOVE 1 TO WS-TARGET
                  PERFORM SIMPLE-SCORE
               WHEN "twos"
                  MOVE 2 TO WS-TARGET
                  PERFORM SIMPLE-SCORE
               WHEN "threes"
                  MOVE 3 TO WS-TARGET
                  PERFORM SIMPLE-SCORE
               WHEN "fours"
                  MOVE 4 TO WS-TARGET
                  PERFORM SIMPLE-SCORE
               WHEN "fives"
                  MOVE 5 TO WS-TARGET
                  PERFORM SIMPLE-SCORE
               WHEN "sixes"
                  MOVE 6 TO WS-TARGET
                  PERFORM SIMPLE-SCORE
               WHEN "full house"
                  PERFORM IS-FULL-HOUSE
                  IF WS-IS-FULL-HOUSE IS EQUAL TO 1 THEN
                     PERFORM VARYING WS-I
                     FROM 1 BY 1
                     UNTIL WS-I > 5
                     ADD WS-DIE(WS-I) TO WS-RESULT
                     END-PERFORM
                  END-IF
               WHEN "four of a kind"
                  PERFORM IS-FOUR-OF-A-KIND
                  IF WS-IS-FOUR-OF-A-KIND IS EQUAL TO 1 THEN
                     PERFORM VARYING WS-I
                     FROM 1 BY 1
                     UNTIL WS-I > 6
                        IF WS-COUNT-ELEMENT(WS-I) IS GREATER THAN OR EQUAL TO 4 THEN
                           MULTIPLY 4 BY WS-DIE(WS-COUNT-ELEMENT(WS-I))
                           GIVING WS-RESULT
                        END-IF
                     END-PERFORM
                  END-IF
               WHEN "little straight"
                  PERFORM IS-LITTLE-STRAIGHT
                  IF WS-IS-STRAIGHT IS EQUAL TO 1 THEN
                     MOVE 30 TO WS-RESULT
                  END-IF
               WHEN "big straight"
                  PERFORM IS-BIG-STRAIGHT
                  IF WS-IS-STRAIGHT IS EQUAL TO 1 THEN
                     MOVE 30 TO WS-RESULT
                  END-IF
               WHEN "choice"
                  PERFORM VARYING WS-I
                  FROM 1 BY 1
                  UNTIL WS-I > 5
                     ADD WS-DIE(WS-I) TO WS-RESULT
                  END-PERFORM
               WHEN "yacht"
                  PERFORM IS-YACHT
                  IF WS-IS-YACHT IS EQUAL TO 1
                     MOVE 50 TO WS-RESULT
            END-EVALUATE.
      
         SIMPLE-SCORE.
            MOVE 0 TO WS-COUNT.
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 5
               IF WS-DIE(WS-I) IS EQUAL TO WS-TARGET
                  ADD 1 TO WS-COUNT
            END-PERFORM.
            MULTIPLY WS-COUNT BY WS-TARGET GIVING WS-RESULT.

         IS-FULL-HOUSE.
            MOVE 0 TO WS-IS-FULL-HOUSE.
            PERFORM COUNTS.
            PERFORM IS-PAIR-PRESENT.
            PERFORM IS-TRIS-PRESENT.
            IF WS-IS-PAIR-PRESENT IS EQUAL TO 1
            AND WS-IS-TRIS-PRESENT IS EQUAL TO 1
               MOVE 1 TO WS-IS-FULL-HOUSE.

         COUNTS.
         MOVE ZEROS TO WS-COUNT-ARRAY.
         PERFORM VARYING WS-I
         FROM 1 BY 1
         UNTIL WS-I > 5
            ADD 1 TO WS-COUNT-ELEMENT(WS-DIE(WS-I))
         END-PERFORM.
      
         IS-PAIR-PRESENT.
            MOVE 0 TO WS-IS-PAIR-PRESENT.
            PERFORM VARYING WS-I
            FROM 1 BY 1
            UNTIL WS-I > 6
               IF WS-COUNT-ELEMENT(WS-I) IS EQUAL TO 2 THEN
                  MOVE 1 TO WS-IS-PAIR-PRESENT
               END-IF
            END-PERFORM.
            
         IS-TRIS-PRESENT.
            MOVE 0 TO WS-IS-TRIS-PRESENT.
            PERFORM VARYING WS-I
            FROM 1 BY 1
            UNTIL WS-I > 6
               IF WS-COUNT-ELEMENT(WS-I) IS EQUAL TO 3 THEN
                  MOVE 1 TO WS-IS-TRIS-PRESENT
               END-IF
            END-PERFORM.

         IS-FOUR-OF-A-KIND.
            MOVE 0 TO WS-IS-FOUR-OF-A-KIND.
            PERFORM COUNTS.
            PERFORM VARYING WS-I
            FROM 1 BY 1
            UNTIL WS-I > 6
               IF WS-COUNT-ELEMENT(WS-I) IS GREATER THAN OR EQUAL TO 4 THEN
                  MOVE 1 TO WS-IS-FOUR-OF-A-KIND
               END-IF
            END-PERFORM.

         IS-LITTLE-STRAIGHT.
            MOVE 0 TO WS-IS-STRAIGHT.
            SORT WS-DIE ASCENDING.
            IF WS-DICE IS EQUAL TO 12345 THEN
               MOVE 1 TO WS-IS-STRAIGHT.
      
         IS-BIG-STRAIGHT.
            MOVE 0 TO WS-IS-STRAIGHT.
            SORT WS-DIE ASCENDING.
            IF WS-DICE IS EQUAL TO 23456 THEN
               MOVE 1 TO WS-IS-STRAIGHT.

         IS-YACHT.
            MOVE 0 TO WS-IS-YACHT.
            PERFORM COUNTS.
            PERFORM VARYING WS-I
            FROM 1 BY 1
            UNTIL WS-I > 6
               IF WS-COUNT-ELEMENT(WS-I) IS EQUAL TO 5 THEN
                  MOVE 1 TO WS-IS-YACHT
               END-IF
            END-PERFORM.
