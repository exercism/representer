       IDENTIFICATION DIVISION.
       PROGRAM-ID. raindrops.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER  PIC 9(4).
       01 WS-RESULT  PIC X(20).
       01 WS-STRING3 PIC X(5) VALUE "Pling".
       01 WS-STRING5 PIC X(5) VALUE "Plang".
       01 WS-STRING7 PIC X(5) VALUE "Plong".

       PROCEDURE DIVISION.
       RAINDROPS.
         MOVE WS-NUMBER TO WS-RESULT
         IF WS-RESULT = " " THEN 
      * THE NUMBER IS EMPTY
            MOVE "0000" TO WS-RESULT
            EXIT
         END-IF
         IF FUNCTION MOD(WS-NUMBER, 3) = 0 THEN
      * 3 IS A FACTOR
            MOVE "Pling" TO WS-RESULT
         END-IF
         IF FUNCTION MOD(WS-NUMBER, 5) = 0 THEN
      * 5 IS A FACTOR
            IF FUNCTION MOD(WS-NUMBER, 3) = 0 THEN
      *    3 IS ALSO A FACTOR, SO ADD "Plang" TO WS-RESULT
               MOVE "Plang" TO WS-RESULT(6:5)
            ELSE
      *    3 IS NOT A FACTOR, SO IT WILL START WITH "Plang"
               MOVE "Plang" TO WS-RESULT
            END-IF
         END-IF
         IF FUNCTION MOD(WS-NUMBER, 7) = 0 THEN
      * 7 IS A FACTOR, SO IT WILL AT LEAST SAY "Plong"
            IF FUNCTION MOD(WS-NUMBER, 3) = 0 THEN
      *    3 IS A FACTOR, SO IT WILL AT LEAST SAY "PlingPlong"
               IF FUNCTION MOD(WS-NUMBER, 5) = 0 THEN
      *       5 IS ALSO A FACTOR, SO IT WILL SAY "PlingPlangPlong"
                  MOVE "Plong" TO WS-RESULT(11:5)
               ELSE
      *       5 IS NOT A FACTOR, SO IT WILL ONLY SAY "PlingPlong"
                  MOVE "Plong" TO WS-RESULT(6:5)
            ELSE
      *    3 IS NOT A FACTOR
               IF FUNCTION MOD(WS-NUMBER, 5) = 0 THEN
      *       5 IS THE FIRST FACTOR, SO IT WILL SAY "PlangPlong"
                  MOVE "Plong" TO WS-RESULT(6:5)
               ELSE
      *       5 IS NOT A FACTOR EITHER, SO 7 IS THE ONLY FACTOR, SO IT WILL ONLY SAY "Plong"
                  MOVE "Plong" TO WS-RESULT
               END-IF
            END-IF
         END-IF
      * NONE ARE FACTORS, SO THE ANSWER IS THE NUMBER ITSELF
         IF FUNCTION MOD(WS-NUMBER, 3) IS NOT EQUAL 0 AND 
            FUNCTION MOD(WS-NUMBER, 5) IS NOT EQUAL 0 AND
            FUNCTION MOD(WS-NUMBER, 7) IS NOT EQUAL 0 THEN
               MOVE WS-NUMBER TO WS-RESULT          
         END-IF.
         EXIT.
         