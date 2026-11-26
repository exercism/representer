       IDENTIFICATION DIVISION.
       PROGRAM-ID. armstrong-numbers.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC X(8).
       01 WS-RESULT PIC 9.
       01 COUNTER PIC 9.
       01 REAL_LEN PIC 9.
       01 WS-REAL-NUMBER PIC 9(7).
       01 ARM_RESULT PIC 9(7) VALUE ZERO.
       01 TEMP PIC 9(7) VALUE 0.
       01 RESTO PIC 9.

       PROCEDURE DIVISION.
       ARMSTRONG-NUMBERS.
      
       PERFORM EXTRACT_REAL_LEN.
        
        IF REAL_LEN IS EQUAL TO 1 THEN
           MOVE 1 TO WS-RESULT
        END-IF.
        
        IF REAL_LEN IS EQUAL TO 2 THEN 
           MOVE 0 TO WS-RESULT
        END-IF.
          
        
        IF REAL_LEN >= 3
      
           MOVE WS-REAL-NUMBER TO TEMP
           MOVE 0 TO ARM_RESULT
           PERFORM SUM_DIGITS UNTIL WS-REAL-NUMBER = 0
           IF ARM_RESULT = TEMP THEN
      *        es numero armstrom
               MOVE 1 TO WS-RESULT
           ELSE
      *         no es numero armstrom
               MOVE 0 TO WS-RESULT
           END-IF
        END-IF.
       
       EXTRACT_REAL_LEN.
           MOVE WS-NUMBER TO WS-REAL-NUMBER
           MOVE 0 TO counter
           INSPECT WS-NUMBER TALLYING counter FOR all SPACES
           COMPUTE REAL_LEN = LENGTH OF WS-NUMBER - COUNTER.
       
       SUM_DIGITS.
           DIVIDE WS-REAL-NUMBER BY 10 GIVING WS-REAL-NUMBER 
           REMAINDER RESTO.
           COMPUTE ARM_RESULT = ARM_RESULT + resto**REAL_LEN.
           
          
           
