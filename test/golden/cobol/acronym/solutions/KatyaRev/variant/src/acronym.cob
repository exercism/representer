       IDENTIFICATION DIVISION.
       PROGRAM-ID. acronym.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION. 
       REPOSITORY.FUNCTION ALL INTRINSIC. 
       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-ACRONYM               PIC X(80).
       01 WS-CAPS                  PIC X(80).
       01 WS-RESULT                PIC X(20).
       01 WS-IDX                   PIC 99.

       PROCEDURE DIVISION.
       ABBREVIATE.
          MOVE SPACE TO WS-RESULT.
          MOVE UPPER-CASE(WS-ACRONYM) TO WS-CAPS.
          MOVE SUBSTITUTE(WS-CAPS,"-"," ") TO WS-CAPS.
          MOVE SUBSTITUTE(WS-CAPS,"_"," ") TO WS-CAPS.
          MOVE SUBSTITUTE(WS-CAPS,"   "," ") TO WS-CAPS.
          MOVE WS-CAPS(1:1) TO WS-RESULT(1:1)
          PERFORM VARYING WS-IDX FROM 2 BY 1 UNTIL WS-IDX >= 79
             IF WS-CAPS(WS-IDX:1) = SPACE
                STRING TRIM(WS-RESULT), WS-CAPS(WS-IDX + 1:1) 
                  INTO WS-RESULT
             END-IF   
          END-PERFORM.