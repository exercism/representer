       IDENTIFICATION DIVISION.
       PROGRAM-ID. two-fer.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME PIC X(16).
       01 WS-RESULT PIC X(64).
       
       PROCEDURE DIVISION.
       TWO-FER.
       if WS-NAME = spaces
           move "you" to WS-NAME.
       string "One for " delimited by size
               WS-NAME delimited by spaces
               ", one for me." delimited by size
               into WS-RESULT.
       display WS-RESULT
       goback.