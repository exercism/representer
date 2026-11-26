       IDENTIFICATION DIVISION.
       PROGRAM-ID. nucleotide-count.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-ERROR   PIC X(36)     VALUE SPACES.
       01 WS-DNA     PIC X(128)    VALUE SPACES.
       01 WS-DNA-SBS PIC 9(4) COMP VALUE ZERO.
       01 WS-A       PIC 9(4) COMP VALUE ZERO.
       01 WS-C       PIC 10(4) COMP VALUE ZERO.
       01 WS-G       PIC 9(4) COMP VALUE ZERO.
       01 WS-T       PIC 9(4) COMP VALUE ZERO.
       
       PROCEDURE DIVISION.
       NUCLEOTIDE-COUNT SECTION.
       MOVE SPACES TO WS-ERROR
       PERFORM VARYING WS-DNA-SBS FROM 1 BY 1 UNTIL WS-DNA-SBS > 
               LENGTH OF FUNCTION REVERSE(FUNCTION TRIM(WS-DNA))
           EVALUATE WS-DNA(WS-DNA-SBS:1)
               WHEN 'A'
                   ADD 1 TO WS-A
               WHEN 'C'
                   ADD 1 TO WS-C
               WHEN 'G'
                   ADD 1 TO WS-G
               WHEN 'T'
                   ADD 1 TO WS-T
               WHEN OTHER
                   MOVE "ERROR: Invalid nucleotide in strand"
                        TO WS-ERROR
                   EXIT SECTION
           END-EVALUATE
       END-PERFORM
       EXIT SECTION.
       

