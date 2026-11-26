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
       01 WS-ERROR PIC X(36).
       01 WS-X PIC 9(4).

       PROCEDURE DIVISION.
       NUCLEOTIDE-COUNT.
           MOVE 0 TO WS-X
           IF WS-DNA NOT = SPACES
              INSPECT WS-DNA TALLYING WS-A FOR ALL 'A'
              INSPECT WS-DNA TALLYING WS-C FOR ALL 'C'
              INSPECT WS-DNA TALLYING WS-G FOR ALL 'G'
              INSPECT WS-DNA TALLYING WS-T FOR ALL 'T'
              INSPECT WS-DNA TALLYING WS-X FOR ALL 'X'
           END-IF
           IF WS-X > 0
              MOVE 'ERROR: Invalid nucleotide in strand' TO WS-ERROR
           .

