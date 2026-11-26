       IDENTIFICATION DIVISION.
       PROGRAM-ID. nucleotide-count.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-DNA PIC X(128).
       01 WS-A PIC 9(4).
       01 WS-C PIC 9(4).
       01 WS-G PIC 9(4).
       01 WS-T PIC 9(4).
       01 WS-VALID PIC X.
       01 WS-ERROR PIC X(36).
       01 WS-CONT PIC 99.
       01 WS-LETRA PIC X. 

       PROCEDURE DIVISION.
       NUCLEOTIDE-COUNT.
       PERFORM VARYING WS-CONT FROM 1 BY 1 
            UNTIL WS-DNA(WS-CONT:2) = '  '
            OR WS-CONT > FUNCTION LENGTH(WS-DNA)
         MOVE WS-DNA(WS-CONT:1) TO WS-LETRA
         EVALUATE WS-LETRA
            WHEN 'A'
                  ADD 1 TO WS-A
            WHEN 'C'
                  ADD 1 TO WS-C
            WHEN 'G'
                  ADD 1 TO WS-G
            WHEN 'T'
                  ADD 1 TO WS-T
            WHEN OTHER
                  MOVE 'ERROR: Invalid nucleotide in strand' TO WS-ERROR
         END-EVALUATE
       END-PERFORM.
         
      
       

