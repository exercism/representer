       IDENTIFICATION DIVISION.
       PROGRAM-ID. KNAPSACK IS RECURSIVE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-INPUTS.
           05 MAXIMUM-WEIGHT    PIC 999.
           05 NO-OF-ITEMS       PIC 99.
           05 KNAPSACKTABLE.
             07 WS-ELEMENT OCCURS 1 TO 20 DEPENDING ON NO-OF-ITEMS
              INDEXED BY WS-IDX.
                10 WS-WEIGHT    PIC 999.
                10 WS-VALUE     PIC 999.

       01 WS-INT.
           05 WS-WEIGHTSUM      PIC 99999.
           05 WS-VALUESUM       PIC 99999.
           05 WS-TAKEN OCCURS 1 TO 20 DEPENDING ON NO-OF-ITEMS 
                                PIC 9 VALUE 1.
      
       01 WS-OUTPUTS.
           05 WS-RESULT         PIC 99999.

       PROCEDURE DIVISION.
       MAXIMUM-VALUE.  
       MOVE 1 TO WS-IDX
       MOVE 1 TO WS-WEIGHTSUM
       MOVE ZERO TO WS-VALUESUM
       MOVE ZERO TO WS-RESULT

      * when WS-WEIGHTSUM = 0, all permutations have been tested
       PERFORM UNTIL WS-WEIGHTSUM = 0
         MOVE ZERO TO WS-WEIGHTSUM
         MOVE ZERO TO WS-VALUESUM

      * test current permutation, first permutation is taking all items
         PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > NO-OF-ITEMS
            IF WS-TAKEN(WS-IDX) = 1 THEN
               ADD WS-WEIGHT(WS-IDX) TO WS-WEIGHTSUM
               ADD WS-VALUE(WS-IDX) TO WS-VALUESUM
            END-IF
         END-PERFORM

      * if result is within weight limit, check if new max found
         IF WS-WEIGHTSUM <= MAXIMUM-WEIGHT THEN
            IF WS-VALUESUM > WS-RESULT THEN
               MOVE WS-VALUESUM TO WS-RESULT
            END-IF
         END-IF

      * decrement permutation "binary" counter. 
      * last test (default case) is "0" (taking nothing, 0 value)
         PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX >= NO-OF-ITEMS
            IF WS-TAKEN(WS-IDX) = 0 THEN MOVE 1 TO WS-TAKEN(WS-IDX)
            ELSE 
               MOVE 0 TO WS-TAKEN(WS-IDX)
               MOVE 21 TO WS-IDX
            END-IF
         END-PERFORM
       END-PERFORM
       .