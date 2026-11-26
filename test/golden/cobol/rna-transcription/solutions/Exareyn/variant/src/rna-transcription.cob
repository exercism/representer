       IDENTIFICATION DIVISION.
       PROGRAM-ID. rna-transcription.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-COMPLEMENT PIC X(64).
       01 WS-DNA PIC X(4) VALUE "ACGT".
       01 I pic 9(2).

       PROCEDURE DIVISION.
       RNA-TRANSCRIPTION.
       move function length(function trim(WS-COMPLEMENT)) to I.
       perform varying I from I by -1 until I <= 1
          evaluate WS-COMPLEMENT(I:1)
             when "A"
                move "U" to WS-COMPLEMENT(I:1)
             when "C"
                move "G" to WS-COMPLEMENT(I:1)
             when "G"
                move "C" to WS-COMPLEMENT(I:1)
             when "T"
                move "A" to WS-COMPLEMENT(I:1)
             when " "
                move " " to WS-COMPLEMENT(I:1)
          end-evaluate
       end-perform

