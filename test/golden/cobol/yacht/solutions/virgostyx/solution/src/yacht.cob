       IDENTIFICATION DIVISION.
       PROGRAM-ID. YACHT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RESULT        PIC 99 VALUE 0.
       01 WS-CATEGORY      PIC X(15).
      
       01 WS-DICE          PIC 9(5).
       01 WS-DES REDEFINES WS-DICE.
          05 WS-DE         PIC 9  OCCURS 5 TIMES.
      
       01 WS-DIGIT         PIC 9.
       01 WS-DIGIT-COUNT   PIC 9.
       01 WS-FACE          PIC 9.
       01 WS-NB-INVALIDES  PIC 9  VALUE ZERO.

       01 WS-COMPTEURS.
          05 WS-NB         PIC 9  OCCURS 6 TIMES.
       01 WS-NB-BRELAN     PIC 9  VALUE ZERO.
       01 WS-NB-PAIRE      PIC 9  VALUE ZERO.
       
       01 WS-I             PIC 99.
       01 WS-POS             PIC 999 VALUE ZERO.
       01 WS-SOMME         PIC 99 VALUE ZERO.

       01 WS-SUITE         PIC X  VALUE "O".
          88 SUITE-OK             VALUE "O".
          88 SUITE-KO             VALUE "N".
       01 WS-SUITE-LOWEST  PIC 9.
       01 WS-SUITE-HIGHEST PIC 9. 
       01 WS-SUITE-COUNT   PIC 9  VALUE ZERO.
       01 WS-SUITE-CIBLE   PIC 9  VALUE ZERO.

       01 WS-CARRE         PIC X  VALUE "N".
          88 CARRE-OK             VALUE "O".
          88 CARRE-KO             VALUE "N".

       01 WS-YACHT         PIC X  VALUE "N".
          88 YACHT-OK             VALUE "O".
          88 YACHT-KO             VALUE "N".

       01 WS-SOURCE        PIC X(15) VALUE SPACES.
       01 WS-RESULTAT      PIC X(15) VALUE SPACES.

       01 WS-CAR           PIC X.
          88 CAR-A-SUPPRIMER       VALUE " " "-" "_".
      
       PROCEDURE DIVISION.
       YACHT.
          PERFORM VALIDER-INPUT
          PERFORM VALIDER-DES
      
          IF WS-NB-INVALIDES > 0
             DISPLAY WS-DICE " contient une face invalide (1 a 6)"
          ELSE  
             PERFORM EVALUER-CATEGORY
          END-IF      

          DISPLAY "Voici le resultat : " WS-RESULT.
      
       VALIDER-INPUT.
         MOVE WS-CATEGORY TO WS-SOURCE
         PERFORM METTRE-EN-MINUSCULES
         PERFORM SUPPRIMER-SEPARATEURS
         MOVE WS-RESULTAT TO WS-CATEGORY.
         
      
       VALIDER-DES.
         MOVE ZERO TO WS-NB-INVALIDES
         INSPECT WS-DICE TALLYING WS-NB-INVALIDES
                 FOR ALL "0" ALL "7" ALL "8" ALL "9".

       METTRE-EN-MINUSCULES.
         INSPECT WS-SOURCE CONVERTING "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                 TO "abcdefghijklmnopqrstuvwxyz".

       SUPPRIMER-SEPARATEURS.
         MOVE SPACES TO WS-RESULTAT
         MOVE ZERO   TO WS-POS
    
         PERFORM VARYING WS-I FROM 1 BY 1
                 UNTIL WS-I > LENGTH OF WS-SOURCE
            MOVE WS-SOURCE(WS-I:1) TO WS-CAR
        
            IF NOT CAR-A-SUPPRIMER
               ADD 1 TO WS-POS
               MOVE WS-CAR TO WS-RESULTAT(WS-POS:1)
            END-IF
         END-PERFORM.
      
       EVALUER-CATEGORY.
         EVALUATE WS-CATEGORY
            WHEN "ones"
               MOVE 1 TO WS-DIGIT
               PERFORM GET-SCORE-FOR-DIGIT
      
            WHEN "twos"
               MOVE 2 TO WS-DIGIT
               PERFORM GET-SCORE-FOR-DIGIT
      
            WHEN "threes"
               MOVE 3 TO WS-DIGIT
               PERFORM GET-SCORE-FOR-DIGIT
      
            WHEN "fours"
               MOVE 4 TO WS-DIGIT
               PERFORM GET-SCORE-FOR-DIGIT
      
            WHEN "fives"
               MOVE 5 TO WS-DIGIT
               PERFORM GET-SCORE-FOR-DIGIT
      
            WHEN "sixes"
               MOVE 6 TO WS-DIGIT
               PERFORM GET-SCORE-FOR-DIGIT
      
            WHEN "fullhouse"
               PERFORM VERIFIER-FULL
      
            WHEN "fourofakind"
               PERFORM VERIFIER-CARRE
      
            WHEN "littlestraight"
               MOVE 1 TO WS-SUITE-LOWEST
               MOVE 5 TO WS-SUITE-HIGHEST
               PERFORM VERIFIER-SUITE
      
            WHEN "bigstraight"
               MOVE 2 TO WS-SUITE-LOWEST
               MOVE 6 TO WS-SUITE-HIGHEST
               PERFORM VERIFIER-SUITE
      
            WHEN "choice"
               PERFORM CALCULER-SOMME
               MOVE WS-SOMME TO WS-RESULT
            WHEN "yacht"
               PERFORM VERIFIER-YACHT
         END-EVALUATE.
      
       GET-SCORE-FOR-DIGIT.
         MOVE ZERO TO WS-DIGIT-COUNT
         INSPECT WS-DICE TALLYING WS-DIGIT-COUNT FOR ALL WS-DIGIT
         MULTIPLY WS-DIGIT BY WS-DIGIT-COUNT GIVING WS-RESULT.

       CALCULER-SOMME.
         MOVE ZERO TO WS-SOMME
         PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 5
            ADD WS-DE(WS-I) TO WS-SOMME
         END-PERFORM.

       COMPTER-FACES.
         INITIALIZE WS-COMPTEURS
    
         PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 5
            ADD 1 TO WS-NB(WS-DE(WS-I))
         END-PERFORM.

       VERIFIER-FULL.
         PERFORM COMPTER-FACES
         DISPLAY "Compteurs faces :" WS-NB(2) WS-NB(4)
         MOVE ZERO TO WS-NB-BRELAN WS-NB-PAIRE
         PERFORM VARYING WS-FACE FROM 1 BY 1 UNTIL WS-FACE > 6
            EVALUATE WS-NB(WS-FACE)
               WHEN 3 ADD 1 TO WS-NB-BRELAN
               WHEN 2 ADD 1 TO WS-NB-PAIRE
            END-EVALUATE
         END-PERFORM

         IF WS-NB-BRELAN = 1 AND WS-NB-PAIRE = 1
            PERFORM CALCULER-SOMME
            MOVE WS-SOMME TO WS-RESULT
         ELSE
            MOVE ZERO TO WS-RESULT
         END-IF.

       VERIFIER-SUITE.
         SET SUITE-OK TO TRUE
         MOVE 30 TO WS-RESULT
      
         PERFORM VARYING WS-SUITE-CIBLE FROM WS-SUITE-LOWEST BY 1 
                 UNTIL WS-SUITE-CIBLE > WS-SUITE-HIGHEST OR SUITE-KO
            MOVE ZERO TO WS-SUITE-COUNT
            INSPECT WS-DICE TALLYING WS-SUITE-COUNT 
                    FOR ALL WS-SUITE-CIBLE

            IF WS-SUITE-COUNT NOT = 1
               SET SUITE-KO TO TRUE
               MOVE ZERO TO WS-RESULT
            END-IF
         END-PERFORM.

       VERIFIER-CARRE.
         SET CARRE-KO TO TRUE
         MOVE ZERO TO WS-RESULT
         PERFORM COMPTER-FACES
         PERFORM VARYING WS-FACE FROM 1 BY 1 
                 UNTIL WS-FACE > 6 OR CARRE-OK
            IF WS-NB(WS-FACE) = 4 OR 5
               MULTIPLY WS-FACE BY 4 GIVING WS-RESULT
               SET CARRE-OK TO TRUE
            END-IF
         END-PERFORM.

       VERIFIER-YACHT.
         SET YACHT-KO TO TRUE
         MOVE ZERO TO WS-RESULT
         PERFORM COMPTER-FACES
         PERFORM VARYING WS-FACE FROM 1 BY 1 
                 UNTIL WS-FACE > 6 OR CARRE-OK
            IF WS-NB(WS-FACE) = 5
               MOVE 50 TO WS-RESULT
               SET CARRE-OK TO TRUE
            END-IF
         END-PERFORM.
      