       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEAP.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  ws-year                pic 9(4).
       01  ws-remainder           pic 999.
       01  ws-temp                pic 9(4).
       01  ws-divisible-by-4      pic a value 'N'.
       01  ws-divisible-by-100    pic a value 'N'.
       01  ws-divisible-by-400    pic a value 'N'.       
       01  ws-result              pic 9. 
       PROCEDURE DIVISION.
       LEAP.
      *> Variables aren't reset between tests, need to manually reset them here...
           move 'N' to ws-divisible-by-4 
           move 'N' to ws-divisible-by-100
           move 'N' to ws-divisible-by-400
           move 0 to ws-result 

           divide ws-year by 4 
           giving ws-temp remainder ws-remainder. 
           
           if ws-remainder = 0 then 
               move 'Y' to ws-divisible-by-4
           end-if 
           
           divide ws-year by 100 
           giving ws-temp remainder ws-remainder

           if ws-remainder = 0 then 
               move 'Y' to ws-divisible-by-100
           end-if 

           divide ws-year by 400 
           giving ws-temp remainder ws-remainder

           if ws-remainder = 0 then 
               move 'Y' to ws-divisible-by-400
           end-if 

           if ws-divisible-by-4 = 'Y' then 
               if ws-divisible-by-100 = 'Y' then 
                   if ws-divisible-by-400 = 'Y' then 
                       move 1 to ws-result                      
                   end-if 
               else 
                   move 1 to ws-result               
               end-if 
           end-if 
           CONTINUE.
       LEAP-EXIT.
           EXIT.
