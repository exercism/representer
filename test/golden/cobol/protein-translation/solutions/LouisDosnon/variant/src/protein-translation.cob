       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROTEIN-TRANSLATION.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-INPUT                  PIC X(60).
       01 WS-PROTEIN                PIC X(120).
       01 WS-ERROR                  PIC X(60).
       01 WS-LENGTH                 PIC 99.
       01 i                         PIC 99.
       01 WS-INDEX                  PIC 99.
       01 WS-RESTE                  PIC 99.

       PROCEDURE DIVISION.

       TRANSLATE-CODON.
         EVALUATE WS-INPUT
            WHEN "AUG"
               MOVE "Methionine" TO WS-PROTEIN
            WHEN "UUU"
            WHEN "UUC"
               MOVE "Phenylalanine" TO WS-PROTEIN
            WHEN "UUA"
            WHEN "UUG"
               MOVE "Leucine" TO WS-PROTEIN
            WHEN "UCU"
            WHEN "UCC"
            WHEN "UCA"
            WHEN "UCG"
               MOVE "Serine" TO WS-PROTEIN
            WHEN "UAU"
            WHEN "UAC"
               MOVE "Tyrosine" TO WS-PROTEIN
            WHEN "UGU"
            WHEN "UGC"
               MOVE "Cysteine" TO WS-PROTEIN
            WHEN "UGG"
               MOVE "Tryptophan" TO WS-PROTEIN
            WHEN "UAA"
            WHEN "UAG"
            WHEN "UGA"
               MOVE SPACES TO WS-PROTEIN
            WHEN OTHER
               MOVE "Invalid codon" TO WS-ERROR
         END-EVALUATE.

       TRANSLATE-RNA.
         COMPUTE WS-LENGTH = FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT))
         MOVE SPACES TO WS-PROTEIN
         MOVE 0 TO WS-INDEX
         PERFORM VARYING i FROM 1 BY 3 UNTIL i >= WS-LENGTH
            IF WS-INPUT(i:3) EQUALS "UAA" 
               OR WS-INPUT(i:3) EQUALS "UAG" 
               OR WS-INPUT(i:3) EQUALS "UGA"
               EXIT PERFORM
            ELSE IF WS-INDEX NOT = 0
               STRING WS-PROTEIN DELIMITED BY SPACES
                  "," DELIMITED BY SIZE
                  INTO WS-PROTEIN
            END-IF
            EVALUATE WS-INPUT(i:3)
               WHEN "AUG"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Methionine" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN "UUU"
               WHEN "UUC"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Phenylalanine" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN "UUA"
               WHEN "UUG"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Leucine" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN "UCU"
               WHEN "UCC"
               WHEN "UCA"
               WHEN "UCG"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Serine" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN "UAU"
               WHEN "UAC"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Tyrosine" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN "UGU"
               WHEN "UGC"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Cysteine" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN "UGG"
                  STRING WS-PROTEIN DELIMITED BY SPACES
                     "Tryptophan" DELIMITED BY SIZE
                     INTO WS-PROTEIN
               WHEN OTHER
                  MOVE "Invalid codon" TO WS-ERROR
                  EXIT PERFORM
            END-EVALUATE
            ADD 1 TO WS-INDEX
         END-PERFORM.