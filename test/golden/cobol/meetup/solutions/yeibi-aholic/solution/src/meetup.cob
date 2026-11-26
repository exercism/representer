       IDENTIFICATION DIVISION.
       PROGRAM-ID. MEETUP.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-YEAR                  PIC  9(04).
       01 WS-MONTH                 PIC  9(02).
       01 WS-WEEK                  PIC  X(10).
       01 WS-DAYOFWEEK             PIC  X(09).
       01 WS-RESULT                PIC  X(10).

       01 W                        PIC  9(04).
       01 Y                        PIC  9(04).
       01 M                        PIC  9(02).
       01 D                        PIC  9(02).
       01 T2                       PIC  X(12) VALUE '032503514624'.
       01 T REDEFINES T2 OCCURS 12 PIC  9(01).
       01 Y1                       PIC  9(03). 
       01 Y2                       PIC  9(02). 
       01 Y3                       PIC  9(01). 
       01 Q                        PIC  9(01).

       01 WN-DIVIDEND              PIC  9(04).
       01 WN-QUOTIENT              PIC  9(04).
       01 WN-REMAINDER             PIC  9(01).

       PROCEDURE DIVISION. 
       MEETUP.
          MOVE ZEROS TO W D
          MOVE WS-YEAR TO Y
          MOVE WS-MONTH TO M
      
          EVALUATE WS-DAYOFWEEK
             WHEN 'Monday'    MOVE 1 TO Q
             WHEN 'Tuesday'   MOVE 2 TO Q
             WHEN 'Wednesday' MOVE 3 TO Q
             WHEN 'Thursday'  MOVE 4 TO Q
             WHEN 'Friday'    MOVE 5 TO Q
             WHEN 'Saturday'  MOVE 6 TO Q
             WHEN 'Sunday'    MOVE 0 TO Q
          END-EVALUATE

          IF M < 3
             COMPUTE Y = Y - 1
          END-IF

          COMPUTE Y1 = Y / 4
          COMPUTE Y2 = Y / 100
          COMPUTE Y3 = Y / 400
          COMPUTE W  = Y + Y1 - Y2 + Y3 + T(M)
          PERFORM UNTIL D > 0 AND WN-REMAINDER = Q
             ADD 1 TO D W
             DIVIDE W BY 7
                    GIVING WN-QUOTIENT
                    REMAINDER WN-REMAINDER
          END-PERFORM

          EVALUATE WS-WEEK
             WHEN 'first'
                CONTINUE
             WHEN 'second'
                COMPUTE D = D + 7
             WHEN 'third'
                COMPUTE D = D + 14
             WHEN 'fourth'
                COMPUTE D = D + 21
             WHEN 'last'
                EVALUATE WS-MONTH
                   WHEN 04 
                   WHEN 06 
                   WHEN 09 
                   WHEN 11
                      PERFORM UNTIL D > 23
                         COMPUTE D = D + 7
                      END-PERFORM
                   WHEN 02
                      DIVIDE WS-YEAR BY 4
                             GIVING WN-QUOTIENT
                             REMAINDER WN-REMAINDER
                     IF WN-REMAINDER = 0
                         PERFORM UNTIL D > 22
                            COMPUTE D = D + 7
                         END-PERFORM
                     ELSE
                         PERFORM UNTIL D > 21
                            COMPUTE D = D + 7
                         END-PERFORM
                     END-IF
                   WHEN OTHER
                      PERFORM UNTIL D > 24
                         COMPUTE D = D + 7
                      END-PERFORM
                END-EVALUATE
             WHEN 'teenth'
                PERFORM UNTIL D > 12
                   COMPUTE D = D + 7
                END-PERFORM
          END-EVALUATE
          STRING WS-YEAR '-' WS-MONTH '-' D
                 DELIMITED BY SIZE
                 INTO WS-RESULT.