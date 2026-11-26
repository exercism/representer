       IDENTIFICATION DIVISION.
       PROGRAM-ID. BINARY.
      
       ENVIRONMENT DIVISION.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-BINARY                PIC X(60).
       01 WS-DIGITS REDEFINES WS-BINARY 
        OCCURS 60 TIMES INDEXED BY IDX PIC X.
       01 WS-BITVALUE              PIC 9(19).
       01 WS-RESULT                PIC 10000.
       01 WS-ERROR                 PIC X(60). 
       
       PROCEDURE DIVISION.
       DECIMAL.
      * error handling
       MOVE SPACES TO WS-ERROR
       PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > LENGTH OF WS-BINARY
         IF NOT (WS-DIGITS(IDX) = "0" OR WS-DIGITS(IDX) = "1" OR 
                 WS-DIGITS(IDX) = SPACE) THEN
            DISPLAY WS-DIGITS(1)
            IF WS-DIGITS(IDX) IS ALPHABETIC THEN 
               MOVE 
       "error: a number containing non-binary characters is invalid"
                TO WS-ERROR
            ELSE 
               MOVE 
       "error: a number containing non-binary digits is invalid"
                TO WS-ERROR
            END-IF
            NEXT SENTENCE
         END-IF
       END-PERFORM
      
       MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-BINARY)) TO IDX

      * sum bits
       MOVE 1 TO WS-BITVALUE
       MOVE ZERO TO WS-RESULT
       PERFORM VARYING IDX FROM IDX BY -1 UNTIL IDX = 0
         IF WS-DIGITS(IDX) = "1" THEN 
            ADD WS-BITVALUE TO WS-RESULT
         END-IF

         MULTIPLY WS-BITVALUE BY 2 GIVING WS-BITVALUE
       END-PERFORM
       .