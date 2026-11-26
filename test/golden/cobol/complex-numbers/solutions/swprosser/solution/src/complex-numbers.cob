       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPLEX-NUMBERS.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 Z1-RE          PIC S99999.
       01 Z1-IM          PIC S99999.
       01 Z2-RE          PIC S99999.
       01 Z2-IM          PIC S99999. 
       01 RESULT-RE      PIC S99999V9999.
       01 RESULT-IM      PIC S99999V9999.
       01 DIVIDE-BASE    PIC S99999.

       PROCEDURE DIVISION.

       C-REAL.
           MOVE Z1-RE TO RESULT-RE.
           MOVE ZERO TO RESULT-IM.

       C-IMAGINARY.
           MOVE ZERO TO RESULT-RE.
           MOVE Z1-IM TO RESULT-IM.

       C-ADD.
           COMPUTE RESULT-RE = Z1-RE + Z2-RE.
           COMPUTE RESULT-IM = Z1-IM + Z2-IM.

       C-SUB.
           COMPUTE RESULT-RE = Z1-RE - Z2-RE.
           COMPUTE RESULT-IM = Z1-IM - Z2-IM.

       C-MUL.
           COMPUTE RESULT-RE = Z1-RE * Z2-RE - Z1-IM * Z2-IM.
           COMPUTE RESULT-IM = Z1-IM * Z2-RE + Z1-RE * Z2-IM.

       C-DIV.
           COMPUTE DIVIDE-BASE = Z2-RE ** 2 + Z2-IM ** 2.
           COMPUTE RESULT-RE = (Z1-RE * Z2-RE + Z1-IM * Z2-IM)
              / DIVIDE-BASE.
           COMPUTE RESULT-IM = (Z1-IM * Z2-RE - Z1-RE * Z2-IM)
              / DIVIDE-BASE.

       C-ABS.
           COMPUTE RESULT-RE = FUNCTION SQRT(Z1-RE ** 2 + Z1-IM ** 2).
           MOVE ZERO TO RESULT-IM.

       C-CONJUGATE.
           MOVE Z1-RE TO RESULT-RE.
           COMPUTE RESULT-IM = -Z1-IM.
