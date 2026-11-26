       IDENTIFICATION DIVISION.
       PROGRAM-ID. allergies.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-SCORE       PIC 999.
       01 WS-ITEM        PIC X(12).
       01 WS-RESULT      PIC A.
       01 WS-RESULT-LIST  PIC X(108) VALUE SPACES.
       01 WS-NEW-SCORE    PIC 999.
       01 WS-TEMP-LIST    PIC X(108) VALUE SPACES.
       01 WS-LENGTH       PIC 999.
       01 WS-TEST         PIC X(8).
       01 WS-COUNTER      PIC 9.
       01 WS-CHARS        PIC 99.
       01 WS-ALLERGEN-LIST.
           05 WS-VALUE    PIC 999   OCCURS 8 TIMES.
           05 WS-ALLERGEN PIC X(12) OCCURS 8 TIMES.

       PROCEDURE DIVISION.
       ALLERGIC-TO.
      * THIS SECTION POPULATES THE ALLERGEN LIST
           MOVE 1   TO WS-VALUE(1)
           MOVE 2   TO WS-VALUE(2)
           MOVE 4   TO WS-VALUE(3)
           MOVE 8   TO WS-VALUE(4)
           MOVE 16  TO WS-VALUE(5)
           MOVE 32  TO WS-VALUE(6)
           MOVE 64  TO WS-VALUE(7)
           MOVE 128 TO WS-VALUE(8)
           MOVE "eggs"          TO WS-ALLERGEN(1)
           MOVE "peanuts"       TO WS-ALLERGEN(2)
           MOVE "shellfish"     TO WS-ALLERGEN(3)
           MOVE "strawberries"  TO WS-ALLERGEN(4)
           MOVE "tomatoes"      TO WS-ALLERGEN(5)
           MOVE "chocolate"     TO WS-ALLERGEN(6)
           MOVE "pollen"        TO WS-ALLERGEN(7)
           MOVE "cats"          TO WS-ALLERGEN(8)
      ********************************************

      * This function returns a Y or N to the question:
      * Is the patient allergic to WS-ITEM given their WS-SCORE
           IF WS-SCORE = 0 THEN
              DISPLAY "SCORE = 0, SO NO ALLERGIES"
              MOVE "N" TO WS-RESULT 
           ELSE 
              PERFORM DISECT-THE-SCORE
              MOVE 0 TO WS-COUNTER
              INSPECT WS-RESULT-LIST TALLYING WS-COUNTER 
               FOR ALL FUNCTION TRIM(WS-ITEM)
              IF WS-COUNTER = 0 THEN
                 MOVE "N" TO WS-RESULT 
              ELSE 
                 MOVE "Y" TO WS-RESULT
              END-IF 
           END-IF.

       LIST-ALLERGENS.
      * THIS SECTION POPULATES THE ALLERGEN LIST
           MOVE 1   TO WS-VALUE(1)
           MOVE 2   TO WS-VALUE(2)
           MOVE 4   TO WS-VALUE(3)
           MOVE 8   TO WS-VALUE(4)
           MOVE 16  TO WS-VALUE(5)
           MOVE 32  TO WS-VALUE(6)
           MOVE 64  TO WS-VALUE(7)
           MOVE 128 TO WS-VALUE(8)
           MOVE "eggs"          TO WS-ALLERGEN(1)
           MOVE "peanuts"       TO WS-ALLERGEN(2)
           MOVE "shellfish"     TO WS-ALLERGEN(3)
           MOVE "strawberries"  TO WS-ALLERGEN(4)
           MOVE "tomatoes"      TO WS-ALLERGEN(5)
           MOVE "chocolate"     TO WS-ALLERGEN(6)
           MOVE "pollen"        TO WS-ALLERGEN(7)
           MOVE "cats"          TO WS-ALLERGEN(8)
      ********************************************
      * Code this paragraph
           IF WS-SCORE = 0 THEN
              MOVE SPACES TO WS-RESULT-LIST
           ELSE 
              PERFORM DISECT-THE-SCORE
           END-IF.

      * The list of items (and their value) that were tested are:
      * eggs (1)
      * peanuts (2)
      * shellfish (4)
      * strawberries (8)
      * tomatoes (16)
      * chocolate (32)
      * pollen (64)
      * cats (128)
      * NOTE: Each value is a power of 2: 1 = 2^0, 2 = 2^1, 4 = 2^2 ...

      * WS-ITEM is the description, ex. "strawberries"
      * WS-SCORE is the patient's score. 
      * If WS-SCORE = 0, the patient is not allergic to anything
      * WS-RESULT is "Y" or "N"

       DISECT-THE-SCORE.
           DISPLAY "SCORE: " WS-SCORE
           MOVE WS-SCORE TO WS-NEW-SCORE 
           MOVE SPACES TO WS-RESULT-LIST
           MOVE SPACES TO WS-TEMP-LIST
           MOVE 0 TO WS-LENGTH
           MOVE 0 TO WS-CHARS
      * 2^8 = 256 which is higher than anything in our list
      *     PERFORM UNTIL WS-NEW-SCORE = 0
              IF WS-NEW-SCORE >= 256 THEN
                 PERFORM UNTIL WS-NEW-SCORE < 256
                    COMPUTE WS-NEW-SCORE = WS-NEW-SCORE - 256
                    DISPLAY "MUST GET THE SCORE BELOW 256 FOR THIS LIST"
                    DISPLAY "NEW SCORE: " WS-NEW-SCORE
                 END-PERFORM
              END-IF 
              PERFORM VARYING WS-COUNTER FROM 8 BY -1 UNTIL 
               WS-NEW-SCORE = 0
                 IF WS-NEW-SCORE > WS-VALUE(WS-COUNTER) THEN
                    PERFORM UNTIL WS-NEW-SCORE < WS-VALUE(WS-COUNTER)
                       COMPUTE WS-NEW-SCORE = WS-NEW-SCORE - 
                          WS-VALUE(WS-COUNTER)
                       DISPLAY WS-VALUE(WS-COUNTER) " " 
                          WS-ALLERGEN(WS-COUNTER) " IS AN ALLERGEN"
                       DISPLAY "NEW SCORE: " WS-NEW-SCORE 
                       COMPUTE WS-CHARS = FUNCTION LENGTH(
                          FUNCTION TRIM(WS-ALLERGEN(WS-COUNTER)))
                       DISPLAY "CHARS: " WS-CHARS
                       MOVE FUNCTION REVERSE(
                          FUNCTION TRIM(WS-ALLERGEN(WS-COUNTER)))
                          TO WS-TEMP-LIST(WS-LENGTH + 1:WS-CHARS)
                    END-PERFORM
                    IF WS-NEW-SCORE >= 1 THEN
                       COMPUTE WS-LENGTH = WS-LENGTH + WS-CHARS + 1
                       MOVE "," TO WS-TEMP-LIST(WS-LENGTH:1)
                    ELSE 
                       COMPUTE WS-LENGTH = WS-LENGTH + WS-CHARS 
                    END-IF
                    DISPLAY WS-TEMP-LIST
                 ELSE 
                    DISPLAY WS-VALUE(WS-COUNTER) " "
                       WS-ALLERGEN(WS-COUNTER) " IS NOT AN ALLERGEN"
                 END-IF
              END-PERFORM 
           MOVE FUNCTION TRIM(FUNCTION REVERSE(WS-TEMP-LIST)) TO
            WS-RESULT-LIST
           DISPLAY WS-RESULT-LIST.