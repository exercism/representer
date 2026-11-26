       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRIANGLE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *Incoming
       01 WS-SIDES PIC X(20).
       01 WS-A     pic 9(02) VALUE 2.
       01 WS-B     pic 9(02) VALUE 3.
       01 WS-C     pic 9(02) VALUE 4.
       01 WS-PROPERTY PIC X(11). 
      *Outgoing
       01 WS-RESULT PIC 9.
       PROCEDURE DIVISION.
       TRIANGLE.
          UNSTRING WS-SIDES DELIMITED BY "," INTO WS-A WS-B WS-C.
          MOVE 0 TO WS-RESULT.
          MOVE "ERROR" TO WS-PROPERTY.
          IF (WS-A + WS-B + WS-C) = 0
            GOBACK.
          IF (WS-A + WS-B) < WS-C OR
             (WS-B + WS-C) < WS-A OR
             (WS-A + WS-C) < WS-B
            GOBACK.
          MOVE 1 TO WS-RESULT.
          MOVE "ISOSCELES" TO WS-PROPERTY.
          IF WS-A <> WS-B AND WS-A <> WS-C AND WS-B <> WS-C
            MOVE "SCALENE" TO WS-PROPERTY.
          IF WS-A = WS-B AND WS-B = WS-C  
            MOVE "EQUILATERAL" TO WS-PROPERTY.       