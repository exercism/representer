       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIEVE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-LIMIT PIC 9999.
       01 TABLE-NUMBERS.
          03 WS-NUMBERS PIC 999 OCCURS 999 TIMES.
       01 TABLE-RESULTS.
          03 WS-RESULT  PIC 999 OCCURS 168  TIMES. 
       01 WS-COUNT PIC 999.
       01 I PIC 9(4).
       01 N PIC 9(4).
       PROCEDURE DIVISION.
       SIEVE.
          MOVE ZEROS TO WS-COUNT
          MOVE ZEROS TO TABLE-RESULTS
          MOVE ZEROS TO TABLE-NUMBERS
          IF WS-LIMIT < 2
             EXIT PROGRAM
          END-IF
      
          PERFORM VARYING I FROM WS-LIMIT BY -1
            UNTIL (I = 1)
             MOVE I TO WS-NUMBERS(I)
          END-PERFORM

          MOVE 2 TO N
      
          PERFORM UNTIL (TABLE-NUMBERS = ZEROS)
             PERFORM VARYING I FROM N BY 1 
               UNTIL (WS-NUMBERS(I) NOT = ZEROS)
             END-PERFORM
                ADD 1 TO WS-COUNT
                MOVE WS-NUMBERS(I) TO WS-RESULT(WS-COUNT) N
                PERFORM VARYING I 
                   FROM WS-RESULT(WS-COUNT) 
                     BY WS-RESULT(WS-COUNT)
                  UNTIL (I > WS-LIMIT)
                   MOVE ZEROS TO WS-NUMBERS(I)
             END-PERFORM
          END-PERFORM.
       