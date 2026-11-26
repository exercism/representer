       IDENTIFICATION DIVISION.
       PROGRAM-ID. YACHT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RESULT PIC 99 VALUE 0.
       01 WS-CATEGORY PIC X(15).
       01 WS-DICE PIC 9(5).
       01 WS-COUNTNUM PIC 9(1) VALUE 0.
       01 WS-INDEX PIC 9(1) VALUE 1.
       01 WS-SEARCHNUM PIC 9(1).
       01 WS-VERIFYNUM PIC 9(1) VALUE 0.
       01 WS-VERIFYNUM2 PIC 9(1) VALUE 0.
       01 WS-V1COUNT PIC 9(1) VALUE 0.
       01 WS-V2COUNT PIC 9(1) VALUE 0.
       01 WS-FLAGNUM PIC 9(1) VALUE 0.
       01 WS-ROLLVAL PIC 9(1) VALUE 0.
       01 WS-ROLLTOT PIC 9(2) VALUE 0.
       01 WS-ROLLTAB.
           05 WS-ROLLTABLE PIC 9(1) OCCURS 5 TIMES VALUE ZEROS.
          PROCEDURE DIVISION.
          YACHT.
            EVALUATE TRUE
            WHEN WS-CATEGORY = 'ones' OR WS-CATEGORY = 'twos' OR
                 WS-CATEGORY = 'threes' OR WS-CATEGORY = 'fours' OR
                 WS-CATEGORY = 'fives' OR WS-CATEGORY = 'sixes'
                     PERFORM NUMBEREDONES
            WHEN WS-CATEGORY = 'full house'
                     PERFORM FULLHOUSE
            WHEN WS-CATEGORY = 'four of a kind'
                     PERFORM FOUROFAKIND
            WHEN WS-CATEGORY = 'little straight' OR WS-CATEGORY = 'big straight'
                  OR WS-CATEGORY = 'choice'
                     PERFORM STRAIGHTSORCHOICE
            WHEN WS-CATEGORY = 'yacht'
                     PERFORM YACHTCAT
            END-EVALUATE.
            PERFORM YACHTS-EXIT.
         YACHTS-EXIT.
         EXIT.  
            
        NUMBEREDONES.
         EVALUATE TRUE 
         WHEN WS-CATEGORY = 'ones'
            MOVE 1 TO WS-SEARCHNUM
         WHEN WS-CATEGORY = 'twos'
            MOVE 2 TO WS-SEARCHNUM
         WHEN WS-CATEGORY = 'threes'
            MOVE 3 TO WS-SEARCHNUM 
         WHEN WS-CATEGORY = 'fours'
            MOVE 4 TO WS-SEARCHNUM
         WHEN WS-CATEGORY = 'fives'
            MOVE 5 TO WS-SEARCHNUM
         WHEN WS-CATEGORY = 'sixes'
            MOVE 6 TO WS-SEARCHNUM
         END-EVALUATE
          MOVE 0 TO WS-COUNTNUM
          PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5
                  IF WS-DICE(WS-INDEX:1) = WS-SEARCHNUM
                     ADD 1 TO WS-COUNTNUM
                  END-IF
            END-PERFORM.
            MULTIPLY WS-SEARCHNUM BY WS-COUNTNUM GIVING WS-RESULT.
        
         FULLHOUSE.
         MOVE 0 TO WS-VERIFYNUM, WS-VERIFYNUM2, WS-FLAGNUM, WS-RESULT,
                   WS-V1COUNT, WS-V2COUNT
         MOVE WS-DICE(1:1) TO WS-VERIFYNUM
         PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5 OR
            WS-FLAGNUM = 1
            MOVE WS-DICE(WS-INDEX:1) TO WS-ROLLVAL
            EVALUATE TRUE
               WHEN WS-ROLLVAL NOT EQUALS WS-VERIFYNUM AND 
                   WS-VERIFYNUM2 = 0 
                      MOVE WS-ROLLVAL TO WS-VERIFYNUM2
                      ADD WS-ROLLVAL TO WS-RESULT
                      ADD 1 TO WS-V2COUNT
                   WHEN WS-VERIFYNUM2 EQUALS WS-ROLLVAL
                     ADD WS-ROLLVAL TO WS-RESULT
                     ADD 1 TO WS-V2COUNT
                     IF WS-V2COUNT > 3 THEN
                        MOVE 0 TO WS-RESULT
                        MOVE 1 TO WS-FLAGNUM
                     END-IF
                  WHEN WS-VERIFYNUM EQUALS WS-ROLLVAL
                      ADD WS-ROLLVAL TO WS-RESULT
                      ADD 1 TO WS-V1COUNT
                     IF WS-V1COUNT > 3 THEN
                        MOVE 0 TO WS-RESULT
                        MOVE 1 TO WS-FLAGNUM
                     END-IF
                   WHEN OTHER
                     MOVE 0 TO WS-RESULT
                     MOVE 1 TO WS-FLAGNUM
                  END-EVALUATE
         END-PERFORM.
                     
         FOUROFAKIND.
         MOVE 0 TO WS-VERIFYNUM, WS-VERIFYNUM2, WS-FLAGNUM, WS-RESULT,
                   WS-V1COUNT, WS-V2COUNT
         MOVE WS-DICE(1:1) TO WS-VERIFYNUM
         PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX >= 5 OR
            WS-FLAGNUM = 1
            MOVE WS-DICE(WS-INDEX:1) TO WS-ROLLVAL
            EVALUATE TRUE
               WHEN WS-ROLLVAL NOT EQUALS WS-VERIFYNUM AND 
                   WS-VERIFYNUM2 = 0 
                      MOVE WS-ROLLVAL TO WS-VERIFYNUM2
                      ADD 1 TO WS-V2COUNT
                   WHEN WS-VERIFYNUM2 EQUALS WS-ROLLVAL
                     ADD 1 TO WS-V2COUNT
                     IF WS-V2COUNT > 3 THEN
                        MULTIPLY WS-VERIFYNUM2 BY 4 GIVING WS-RESULT
                        MOVE 1 TO WS-FLAGNUM
                     END-IF
                  WHEN WS-VERIFYNUM EQUALS WS-ROLLVAL
                      ADD 1 TO WS-V1COUNT
                     IF WS-V1COUNT > 3 THEN
                        MULTIPLY WS-VERIFYNUM BY 4 GIVING WS-RESULT
                        MOVE 1 TO WS-FLAGNUM
                     END-IF
                   WHEN OTHER
                     MOVE 0 TO WS-RESULT
                     MOVE 1 TO WS-FLAGNUM
                  END-EVALUATE
         END-PERFORM.

       STRAIGHTSORCHOICE.
         MOVE 0 TO WS-FLAGNUM, WS-RESULT, WS-ROLLTOT
          PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5
                  MOVE 0 TO WS-ROLLTABLE(WS-INDEX)
                  IF WS-CATEGORY = 'choice' THEN
                     MOVE 1 TO WS-FLAGNUM
                     MOVE WS-DICE(WS-INDEX:1) TO WS-ROLLVAL
                     ADD WS-ROLLVAL TO WS-ROLLTOT
               END-IF
          END-PERFORM
          MOVE WS-ROLLTOT TO WS-RESULT
          PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5 OR 
                  WS-FLAGNUM = 1
             MOVE WS-DICE(WS-INDEX:1) TO WS-ROLLVAL
             IF WS-CATEGORY = 'little straight' THEN
                IF WS-ROLLVAL = 6 THEN
                  MOVE 0 TO WS-RESULT
                  MOVE 1 TO WS-FLAGNUM
               ELSE
                  MOVE WS-ROLLVAL TO 
                       WS-ROLLTABLE(WS-ROLLVAL)
               END-IF
            ELSE
               IF WS-ROLLVAL = 1 THEN
                  MOVE 0 TO WS-RESULT
                  MOVE 1 TO WS-FLAGNUM
               ELSE
                  SUBTRACT 1 FROM WS-ROLLVAL
                  MOVE WS-ROLLVAL TO
                       WS-ROLLTABLE(WS-ROLLVAL)
               END-IF
            END-IF
         END-PERFORM
         IF WS-FLAGNUM = 0 THEN
            PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5  OR 
            WS-FLAGNUM = 1
               IF WS-ROLLTABLE(WS-INDEX) NOT EQUALS WS-INDEX THEN
                     MOVE 0 TO WS-RESULT
                     MOVE 1 TO WS-FLAGNUM
            END-PERFORM
            IF WS-FLAGNUM = 0 THEN 
                  MOVE 30 TO WS-RESULT
            END-IF
         END-IF.

       YACHTCAT.
         MOVE 0 TO WS-FLAGNUM, WS-RESULT, WS-VERIFYNUM
         MOVE WS-DICE(1:1) TO WS-VERIFYNUM
          PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5 OR
            WS-FLAGNUM = 1
               IF WS-DICE(WS-INDEX:1) NOT EQUALS WS-VERIFYNUM
                     MOVE 0 TO WS-RESULT
                     MOVE 1 TO WS-FLAGNUM
               END-IF
            END-PERFORM
            IF WS-FLAGNUM = 0
               MOVE 50 TO WS-RESULT
            END-IF.
               


         
            
              
               
         
                
             
            
         
         
         
                
         
            
         
