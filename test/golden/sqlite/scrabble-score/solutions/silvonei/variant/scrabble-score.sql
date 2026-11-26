-- Schema: CREATE TABLE "scrabble-score" ( word TEXT NOT NULL, result INTEGER );
-- Task: update scrabble-score table and set the result based on the word.
UPDATE "scrabble-score"
SET result = (
  WITH RECURSIVE
  -- 1. Loop recursivo para extrair caractere por caractere da palavra
  contador_letras(rest, letra_atual, pontos_acumulados) AS (
    -- Caso Base: Começa com a palavra original convertida para maiúscula
    SELECT 
      UPPER(COALESCE(word, '')), 
      '', 
      0
    FROM "scrabble-score" AS cr 
    WHERE cr.rowid = "scrabble-score".rowid
    
    UNION ALL
    
    -- Caso Recursivo: Extrai a primeira letra do 'rest' e calcula os pontos dela
    SELECT
      SUBSTR(rest, 2), -- Remove a letra que acabamos de ler
      SUBSTR(rest, 1, 1), -- Isola a letra atual
      pontos_acumulados + CASE SUBSTR(rest, 1, 1)
        WHEN 'A' THEN 1 WHEN 'E' THEN 1 WHEN 'I' THEN 1 WHEN 'O' THEN 1 WHEN 'U' THEN 2
        WHEN 'L' THEN 1 WHEN 'N' THEN 1 WHEN 'R' THEN 1 WHEN 'S' THEN 1 WHEN 'T' THEN 1
        WHEN 'D' THEN 2 WHEN 'G' THEN 2
        WHEN 'B' THEN 3 WHEN 'C' THEN 3 WHEN 'M' THEN 3 WHEN 'P' THEN 3
        WHEN 'F' THEN 4 WHEN 'H' THEN 4 WHEN 'V' THEN 4 WHEN 'W' THEN 4 WHEN 'Y' THEN 4
        WHEN 'K' THEN 5
        WHEN 'J' THEN 8 WHEN 'X' THEN 8
        WHEN 'Q' THEN 10 WHEN 'Z' THEN 10
        ELSE 0 -- Caso a palavra tenha algum caractere inválido ou espaço
      END
    FROM contador_letras
    WHERE rest <> '' -- Continua o loop enquanto houver letras para ler
  )
  -- 2. Seleciona o total acumulado do final do loop (onde o 'rest' ficou vazio)
  SELECT pontos_acumulados 
  FROM contador_letras 
  WHERE rest = ''
);