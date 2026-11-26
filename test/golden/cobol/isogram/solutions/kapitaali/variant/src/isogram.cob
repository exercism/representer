        IDENTIFICATION DIVISION.
        PROGRAM-ID. ISOGRAM.
        ENVIRONMENT DIVISION.
        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 WS-PHRASE PIC X(60).
        01 WS-RESULT PIC 99.
        01 ITER      PIC 9(2).
        01 WS-TABLE.
           05 WS-A PIC X(1) OCCURS 26 TIMES INDEXED BY I.
        01 WS-CHECK.   
           05 WS-B PIC 9(1) OCCURS 26 TIMES INDEXED BY J.
        01 WS-SRCH PIC X(1).

        PROCEDURE DIVISION.
        ISOGRAM.
           MOVE '11111111111111111111111111' TO WS-CHECK.
           MOVE 'abcdefghijklmnopqrstuvwxyz' TO WS-TABLE.
           PERFORM SEARCH-CHAR VARYING ITER FROM 2 BY 1 UNTIL ITER = 60.
           MOVE 1 TO WS-RESULT.
           STOP RUN.

       SEARCH-CHAR.
           SET I TO 1.
           SET J TO I.
           MOVE FUNCTION LOWER-CASE(WS-PHRASE(ITER:1)) TO WS-SRCH.
           SEARCH WS-A
              WHEN WS-A(I) = WS-SRCH
                 IF WS-B(I) = 0
                    MOVE 0 TO WS-RESULT 
                    GOBACK
                 ELSE
                    MOVE 0 TO WS-B(I)   
                 END-IF                  
           END-SEARCH.
        