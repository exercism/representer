       IDENTIFICATION DIVISION.
       PROGRAM-ID. BOB.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * INPUT
       01 WS-HEYBOB                PIC X(60).
      * OUTPUT
       01 WS-RESULT                PIC X(40).
      * Auxiliary Variables
       01 WS-COUNT PIC 99.
       01 WS-COUNT2 PIC 99.
       01 WS-IDX PIC 99.

      * Boolean results
       01 WS-IS-QUESTIONING PIC 9.
       01 WS-IS-YELLING     PIC 9.
       01 WS-IS-EMPTY       PIC 9.
      
       PROCEDURE DIVISION.
       BOB.
         PERFORM IS-QUESTIONING.
         PERFORM IS-YELLING.
         PERFORM IS-EMPTY.
         EVALUATE TRUE
            WHEN WS-IS-YELLING = 1 AND WS-IS-QUESTIONING = 1
               MOVE "Calm down, I know what I'm doing!" TO WS-RESULT
            WHEN WS-IS-QUESTIONING = 1
               MOVE "Sure." TO WS-RESULT
            WHEN WS-IS-YELLING = 1
               MOVE "Whoa, chill out!" TO WS-RESULT
            WHEN WS-IS-EMPTY = 1
               MOVE "Fine. Be that way!" TO WS-RESULT
            WHEN OTHER
               MOVE "Whatever." TO WS-RESULT
         .
       IS-QUESTIONING.
         MOVE 0 TO WS-IS-QUESTIONING
         MOVE 0 TO WS-COUNT

         MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-HEYBOB)) TO WS-IDX
               
         IF WS-HEYBOB(WS-IDX:1) = "?"
            MOVE 1 TO WS-IS-QUESTIONING
         END-IF
         .
       IS-YELLING.
         MOVE 0 TO WS-IS-YELLING
         MOVE 0 TO WS-COUNT
         MOVE 0 TO WS-COUNT2
      
         PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 60
            IF FUNCTION ORD(WS-HEYBOB(WS-IDX:1)) >= FUNCTION ORD('A') 
               AND FUNCTION ORD(WS-HEYBOB(WS-IDX:1)) <= FUNCTION ORD('Z') 
                  ADD 1 TO WS-COUNT
            END-IF
            IF FUNCTION ORD(WS-HEYBOB(WS-IDX:1)) >= FUNCTION ORD('A') 
               AND FUNCTION ORD(WS-HEYBOB(WS-IDX:1)) <= FUNCTION ORD('Z')
               OR FUNCTION ORD(WS-HEYBOB(WS-IDX:1)) >= FUNCTION ORD('a') 
               AND FUNCTION ORD(WS-HEYBOB(WS-IDX:1)) <= FUNCTION ORD('z')
                  ADD 1 TO WS-COUNT2
            END-IF
         END-PERFORM
      
         IF WS-COUNT = WS-COUNT2 AND WS-COUNT > 0
            MOVE 1 TO WS-IS-YELLING
         END-IF
         .
       IS-EMPTY.
         MOVE 0 TO WS-IS-EMPTY
      
         IF FUNCTION LENGTH(FUNCTION TRIM(WS-HEYBOB)) = 0
            MOVE 1 TO WS-IS-EMPTY
         END-IF
         .