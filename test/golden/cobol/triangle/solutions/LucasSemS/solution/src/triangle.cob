       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRIANGLE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *Incoming
       01 WS-SIDES PIC X(20).
       01 WS-PROPERTY PIC X(11).
       01 WS-A PIC 9V9.
       01 WS-B PIC 9V9.
       01 WS-C PIC 9V9.
      *Outgoing
       01 WS-RESULT PIC 9.
       PROCEDURE DIVISION.
       TRIANGLE.
          UNSTRING WS-SIDES DELIMITED BY ',' INTO WS-A, WS-B, WS-C.
      
          MOVE 0 TO WS-RESULT.
      
          IF FUNCTION MIN(WS-A, WS-B, WS-C) = 0 THEN
             NEXT SENTENCE
          ELSE IF FUNCTION SUM(WS-A, WS-B, WS-C) <= 2 * FUNCTION MAX(WS-A, WS-B, WS-C) THEN
             NEXT SENTENCE
          ELSE IF WS-A = WS-B AND WS-B = WS-C AND WS-PROPERTY = "equilateral" THEN
             MOVE 1 TO WS-RESULT
          ELSE IF (WS-A = WS-B OR WS-B = WS-C OR WS-C = WS-A) AND WS-PROPERTY = "isosceles" THEN
             MOVE 1 TO WS-RESULT
          ELSE IF NOT (WS-A = WS-B OR WS-B = WS-C OR WS-A = WS-C) AND WS-PROPERTY = "scalene" THEN
             MOVE 1 TO WS-RESULT
          END-IF.