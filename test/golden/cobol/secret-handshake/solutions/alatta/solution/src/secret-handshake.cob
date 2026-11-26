       IDENTIFICATION DIVISION.
       PROGRAM-ID. SECRET-HANDSHAKE.
      
       ENVIRONMENT DIVISION.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-INPUT                 PIC 999.

       01 WS-BITS                  PIC 99.
       01 WS-FLAGS.
         05 WS-WINK                PIC 9.
         05 WS-BLINK               PIC 9.
         05 WS-CLOSE               PIC 9.
         05 WS-JUMP                PIC 9.
      
       01 WS-RESULT                PIC X(60).

       PROCEDURE DIVISION.
       COMMANDS. 
       MOVE SPACES TO WS-RESULT
       MOVE ZERO TO WS-FLAGS
      
      * poor man's bitwise AND
       MOVE FUNCTION MOD(WS-INPUT, 16) TO WS-BITS
       IF WS-BITS >= 8 THEN MOVE 1 TO WS-JUMP END-IF
       MOVE FUNCTION MOD(WS-INPUT, 8) TO WS-BITS
       IF WS-BITS >= 4 THEN MOVE 1 TO WS-CLOSE END-IF
       MOVE FUNCTION MOD(WS-INPUT, 4) TO WS-BITS
       IF WS-BITS >= 2 THEN MOVE 1 TO WS-BLINK END-IF
       MOVE FUNCTION MOD(WS-INPUT, 2) TO WS-BITS
       IF WS-BITS >= 1 THEN MOVE 1 TO WS-WINK END-IF
      
      * flags to string
       MOVE FUNCTION MOD(WS-INPUT, 32) TO WS-BITS
       IF WS-BITS < 16 THEN PERFORM FORWARD
       ELSE PERFORM BACKWARD
       END-IF

      * remove trailing comma
       INSPECT WS-RESULT REPLACING ALL ", " BY SPACE
       .

       FORWARD.
       IF WS-WINK = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " "wink," INTO WS-RESULT 
       END-IF
       IF WS-BLINK = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " 
                 "double blink," INTO WS-RESULT 
       END-IF
       IF WS-CLOSE = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " 
                 "close your eyes," INTO WS-RESULT 
       END-IF
       IF WS-JUMP = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " "jump," INTO WS-RESULT 
       END-IF
       .

       BACKWARD.
       IF WS-JUMP = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " "jump," INTO WS-RESULT 
       END-IF
       IF WS-CLOSE = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " 
                 "close your eyes," INTO WS-RESULT 
       END-IF
       IF WS-BLINK = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " 
                 "double blink," INTO WS-RESULT 
       END-IF
       IF WS-WINK = 1 THEN 
          STRING WS-RESULT DELIMITED BY "  " "wink," INTO WS-RESULT 
       END-IF
       .
      