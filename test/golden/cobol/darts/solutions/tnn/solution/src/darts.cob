       IDENTIFICATION DIVISION.
       PROGRAM-ID. DARTS.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-X                     PIC 99V99.
       01 WS-Y                     PIC 99V99.
       01 WS-RESULT                PIC 99.
       01 WS-STATE-OF-DART         PIC 9.
          88 WS-INNER-CIRCLE       VALUE 1.
          88 WS-MIDDLE-CIRCLE      VALUE 2.
          88 WS-OUTER-CIRCLE       VALUE 3.
       01 WS-DISTANCE-FROM-CENTER  PIC 99V9999.
                   
       PROCEDURE DIVISION.
       DARTS.
       COMPUTE WS-DISTANCE-FROM-CENTER = 
                              FUNCTION SQRT ((WS-X**2) + (WS-Y**2)).
       
       MOVE ZEROS TO WS-STATE-OF-DART.
       EVALUATE TRUE
                WHEN WS-DISTANCE-FROM-CENTER LESS OR EQUAL 1
                     SET WS-INNER-CIRCLE TO TRUE
                WHEN WS-DISTANCE-FROM-CENTER GREATER 1
                AND  WS-DISTANCE-FROM-CENTER LESS OR EQUAL 5
                     SET WS-MIDDLE-CIRCLE TO TRUE
                WHEN WS-DISTANCE-FROM-CENTER GREATER 5
                AND  WS-DISTANCE-FROM-CENTER LESS OR EQUAL 10.0000
                     SET WS-OUTER-CIRCLE TO TRUE
       END-EVALUATE.

       DISPLAY 'WS-DISTANCE-FROM-CENTER =' WS-DISTANCE-FROM-CENTER.
       DISPLAY 'WS-STATE-OF-DART =' WS-STATE-OF-DART. 
      
       EVALUATE TRUE
                WHEN WS-INNER-CIRCLE
                     MOVE 10 TO WS-RESULT
                WHEN WS-MIDDLE-CIRCLE
                     MOVE 5 TO WS-RESULT
                WHEN WS-OUTER-CIRCLE
                     MOVE 1 TO WS-RESULT
                WHEN OTHER
                     MOVE ZEROS TO WS-RESULT
       END-EVALUATE.