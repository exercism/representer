-- Schema:
-- CREATE TABLE transpose (
--     lines  TEXT NOT NULL,
--     result TEXT
-- );
--
-- Task: update the transpose table and set the result based on the lines.
UPDATE transpose
SET result = (
  WITH RECURSIVE
  -- 1. Transforma o texto de entrada em uma estrutura de array JSON para isolar cada linha de forma ordenada
  linhas_matriz AS (
    SELECT 
      row_idx.key + 1 AS linha_idx, -- Gera o índice real sequencial (1, 2, 3...)
      row_idx.value AS linha_texto
    FROM transpose AS cr
    -- Envolve cada linha em aspas e colchetes para criar um formato JSON válido
    JOIN json_each('["' || REPLACE(REPLACE(cr.lines, CHAR(13), ''), CHAR(10), '","') || '"]') AS row_idx
    WHERE cr.rowid = transpose.rowid
  ),

  -- 2. Calcula as dimensões máximas reais da matriz atual
  metadados AS (
    SELECT 
      COALESCE(MAX(LENGTH(linha_texto)), 0) AS max_colunas,
      COALESCE(MAX(linha_idx), 0) AS total_linhas
    FROM linhas_matriz
  ),

  -- 3. Sequenciador de colunas antigas (que se transformarão nas novas linhas)
  sequencia_colunas(c_idx) AS (
    SELECT 1 WHERE (SELECT max_colunas FROM metadados) > 0
    UNION ALL
    SELECT c_idx + 1 FROM sequencia_colunas WHERE c_idx < (SELECT max_colunas FROM metadados)
  ),

  -- 4. Sequenciador de linhas antigas (que se transformarão nas novas colunas)
  sequencia_linhas(r_idx) AS (
    SELECT 1 WHERE (SELECT total_linhas FROM metadados) > 0
    UNION ALL
    SELECT r_idx + 1 FROM sequencia_linhas WHERE r_idx < (SELECT total_linhas FROM metadados)
  ),

  -- 5. Une as sequências em uma malha bidimensional estável e indexada
  coordenadas_matriz AS (
    SELECT 
      c.c_idx,
      r.r_idx,
      SUBSTR(l.linha_texto, c.c_idx, 1) AS caractere,
      -- Regra do Padding estrita do Exercism: só adiciona espaço se houver linha maior abaixo
      EXISTS (
        SELECT 1 
        FROM linhas_matriz l2 
        WHERE l2.linha_idx >= r.r_idx 
          AND LENGTH(l2.linha_texto) >= c.c_idx
      ) AS precisa_padding
    FROM sequencia_colunas c
    CROSS JOIN sequencia_linhas r
    LEFT JOIN linhas_matriz l ON l.linha_idx = r.r_idx
  ),
  
  celulas_finais AS (
    SELECT 
      c_idx,
      r_idx,
      CASE 
        WHEN caractere <> '' THEN caractere
        WHEN precisa_padding THEN ' '
        ELSE ''
      END AS char_final
    FROM coordenadas_matriz
  ),

  -- 6. Concatena os caracteres horizontalmente respeitando os eixos estritos da nova matriz
  juntador_horizontal(c_idx, r_idx, texto_acumulado) AS (
    SELECT c_idx, 1, COALESCE(char_final, '')
    FROM celulas_finais 
    WHERE r_idx = 1
    
    UNION ALL
    
    SELECT 
      j.c_idx,
      j.r_idx + 1,
      j.texto_acumulado || COALESCE(c.char_final, '')
    FROM juntador_horizontal j
    JOIN celulas_finais c ON c.c_idx = j.c_idx AND c.r_idx = j.r_idx + 1
  ),
  novas_linhas_prontas AS (
    SELECT c_idx, texto_acumulado AS linha_completa
    FROM juntador_horizontal
    WHERE r_idx = (SELECT total_linhas FROM metadados)
  ),

  -- 7. Empilha as novas colunas gerando as quebras de linha horizontais (\n)
  juntador_vertical(c_idx, texto_final) AS (
    SELECT 1, (SELECT linha_completa FROM novas_linhas_prontas WHERE c_idx = 1)
    FROM metadados WHERE max_colunas > 0
    
    UNION ALL
    
    SELECT 
      jv.c_idx + 1,
      jv.texto_final || CHAR(10) || n.linha_completa
    FROM juntador_vertical jv
    JOIN novas_linhas_prontas n ON n.c_idx = jv.c_idx + 1
  )

  -- 8. Retorna a matriz perfeitamente transposta e trata strings nulas/vazias para o primeiro teste
  SELECT COALESCE((SELECT texto_final FROM juntador_vertical ORDER BY c_idx DESC LIMIT 1), '')
);