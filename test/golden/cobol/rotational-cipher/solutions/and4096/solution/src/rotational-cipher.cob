       IDENTIFICATION DIVISION.
       PROGRAM-ID. rotational-cipher.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-KEY PIC 9(2).
       01 WS-TEXT PIC X(128).
       01 WS-CIPHER PIC X(128).
       01 S           PIC 9(3).
       01 C           PIC 9(3).
       PROCEDURE DIVISION.
       ROTATIONAL-CIPHER.
         MOVE SPACE TO WS-CIPHER
         MOVE FUNCTION UPPER-CASE(WS-TEXT) TO WS-TEXT.
         PERFORM VARYING C FROM 1 BY 1 UNTIL C > FUNCTION
                 LENGTH(FUNCTION TRIM(WS-TEXT TRAILING))
           MOVE FUNCTION ORD(WS-TEXT(C:1)) TO S
           IF S > 65 AND S < 92 THEN
                   COMPUTE S = S + WS-KEY
             IF S > 91 THEN
                     COMPUTE S = S - 26
             END-IF
           END-IF
           MOVE FUNCTION CHAR(S) TO WS-CIPHER(C:1)
         END-PERFORM.
