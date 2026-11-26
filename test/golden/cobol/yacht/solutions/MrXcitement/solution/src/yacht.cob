       IDENTIFICATION DIVISION.
       PROGRAM-ID. YACHT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RESULT PIC 99 VALUE 0.
       01 WS-CATEGORY PIC X(15).
      * The individual dice split into a table of 5 die
       01 WS-DICE.
        05 WS-DIE-TBL OCCURS 5 TIMES INDEXED BY WS-DIE-IDX.
            10 WS-DIE PIC 9.
      * The current die faces as a table of 6 faces per die
       01 WS-FACE.
        05 WS-FACE-TBL OCCURS 6 TIMES INDEXED BY WS-FACE-IDX.
            10 WS-FACE-CNT PIC 9.
      * The face values for two, three, four and fice of a kind
       01 WS-TWO-OF-KIND-1ST-FACE PIC 9 VALUE 0.
       01 WS-TWO-OF-KIND-2ND-FACE PIC 9 VALUE 0.
       01 WS-THREE-OF-KIND-FACE PIC 9.
       01 WS-FOUR-OF-KIND-FACE PIC 9.
       01 WS-FIVE-OF-KIND-FACE PIC 9.
       PROCEDURE DIVISION.
       YACHT.
      *
      * Initialize the calculated variables to zero
        MOVE ZEROS TO WS-RESULT.
        MOVE ZEROS TO WS-FACE.
        MOVE ZEROS TO WS-TWO-OF-KIND-1ST-FACE.
        MOVE ZEROS TO WS-TWO-OF-KIND-2ND-FACE.
        MOVE ZEROS TO WS-THREE-OF-KIND-FACE.
        MOVE ZEROS TO WS-FOUR-OF-KIND-FACE.
        MOVE ZEROS TO WS-FIVE-OF-KIND-FACE.
      *
      * Sort the die by face value and keep track of the number of faces
        SORT WS-DIE-TBL ASCENDING WS-DIE
        PERFORM VARYING WS-DIE-IDX
                FROM 1 BY 1 UNTIL WS-DIE-IDX > 5
            MOVE WS-DIE(WS-DIE-IDX) TO WS-FACE-IDX
            COMPUTE WS-FACE-CNT(WS-FACE-IDX) = WS-FACE-CNT(WS-FACE-IDX) + 1
        END-PERFORM
      *
      * Find the two, three, four and five of a kind face values
        PERFORM FIND-NUMBER-OF-KIND-FACE.
      *
      * For a given category, calculate the score
        EVALUATE WS-CATEGORY
            WHEN "ones"
                MOVE 1 TO WS-FACE-IDX
                PERFORM SCORE-FACES
            WHEN "twos"
                MOVE 2 TO WS-FACE-IDX
                PERFORM SCORE-FACES
            WHEN "threes"
                MOVE 3 TO WS-FACE-IDX
                PERFORM SCORE-FACES
            WHEN "fours"
                MOVE 4 TO WS-FACE-IDX
                PERFORM SCORE-FACES
            WHEN "fives"
                MOVE 5 TO WS-FACE-IDX
                PERFORM SCORE-FACES
            WHEN "sixes"
                MOVE 6 TO WS-FACE-IDX
                PERFORM SCORE-FACES
            WHEN "full house"
                PERFORM SCORE-FULL-HOUSE
            WHEN "four of a kind"
                PERFORM SCORE-FOUR-OF-A-KIND
            WHEN "little straight"
                PERFORM SCORE-LITTLE-STRAIGHT
            WHEN "big straight"
                PERFORM SCORE-BIG-STRAIGHT
            WHEN "choice"
                PERFORM SCORE-CHOICE
            WHEN "yacht"
                PERFORM SCORE-YACHT
            WHEN OTHER
                CONTINUE
        END-EVALUATE.
      *
      * Find the faces of two, three, for and five of a kind
       FIND-NUMBER-OF-KIND-FACE.
        PERFORM VARYING WS-FACE-IDX
               FROM 1 BY 1 UNTIL WS-FACE-IDX > 6
            EVALUATE WS-FACE-CNT(WS-FACE-IDX)
                WHEN 0
                WHEN 1
                    CONTINUE
                WHEN 2
                    IF WS-TWO-OF-KIND-1ST-FACE = 0
                        MOVE WS-FACE-IDX TO WS-TWO-OF-KIND-1ST-FACE
                    ELSE
                        MOVE WS-FACE-IDX TO WS-TWO-OF-KIND-2ND-FACE
                    END-IF
                WHEN 3
                    MOVE WS-FACE-IDX TO WS-THREE-OF-KIND-FACE
                WHEN 4
                    MOVE WS-FACE-IDX TO WS-FOUR-OF-KIND-FACE
                WHEN 5
                    MOVE WS-FACE-IDX TO WS-FIVE-OF-KIND-FACE
            END-EVALUATE
        END-PERFORM.
      *
      * When the category is "ones" thru "sixes"
      * The score is the sum of the face values of the specified face (WS-FACE-IDX)
       SCORE-FACES.
        COMPUTE WS-RESULT = WS-FACE-CNT(WS-FACE-IDX) * WS-FACE-IDX.
      *
      * When two of the die have one face and three have another face.
      * Add up the values of all the dice.
       SCORE-FULL-HOUSE.
        IF WS-TWO-OF-KIND-1ST-FACE > 0 AND WS-THREE-OF-KIND-FACE > 0
            COMPUTE WS-RESULT = (WS-TWO-OF-KIND-1ST-FACE * 2) +
                                (WS-THREE-OF-KIND-FACE * 3)
        END-IF.
      *
      * When four die have the same face value
      * The score is 4 * the face value.
       SCORE-FOUR-OF-A-KIND.
        IF WS-FOUR-OF-KIND-FACE > 0
            COMPUTE WS-RESULT = 4 * WS-FOUR-OF-KIND-FACE
        END-IF
        IF WS-FIVE-OF-KIND-FACE > 0
            COMPUTE WS-RESULT = 4 * WS-FIVE-OF-KIND-FACE
        END-IF.
      *
      * When the dice are 1,2,3,4,5
      * The score is 30
       SCORE-LITTLE-STRAIGHT.
        IF WS-FACE = 111110
            MOVE 30 TO WS-RESULT
        END-IF.
      *
      * When the dice are 2,3,4,5,6
      * The score is 30
       SCORE-BIG-STRAIGHT.
        IF WS-FACE = 011111
            MOVE 30 TO WS-RESULT
        END-IF.
      *
      * When the category is "choice"
      * Add up all the face values
       SCORE-CHOICE.
        PERFORM VARYING WS-DIE-IDX
                FROM 1 BY 1 UNTIL WS-DIE-IDX > 5
            COMPUTE WS-RESULT = WS-RESULT + WS-DIE(WS-DIE-IDX)
        END-PERFORM.
      *
      * When all five die have the same face
      * The score is 50.
       SCORE-YACHT.
        IF WS-FIVE-OF-KIND-FACE > 0
            MOVE 50 TO WS-RESULT
        END-IF.
