-- Schema: CREATE TABLE anagram (
--           subject    TEXT NOT NULL,
--           candidates TEXT NOT NULL,     -- json array of strings
--           result     TEXT               -- json array of strings
--         );
-- Task: update the anagram table and set the result based on valid
--       candidates for the subject field
--       * the candidates column contains a JSON-encoded list of strings.
--       * the result column should contain JSON-encoded list of
--         strings as well.
UPDATE anagram
SET result = (
    WITH RECURSIVE
    -- 1. Captura e isola os dados da linha atual limpando o escopo por rowid
    contexto AS (
        SELECT 
            UPPER(subject) AS alvo_upper,
            candidates AS cand_json
        FROM anagram AS a
        WHERE a.rowid = anagram.rowid
    ),
    -- 2. Explode a lista JSON de palavras candidatas em linhas de texto comuns
    lista_candidatas AS (
        SELECT 
            CAST(c.key AS INT) AS cand_idx,
            c.value AS cand_original,
            UPPER(c.value) AS cand_upper
        FROM contexto, json_each(contexto.cand_json) AS c
    ),
    -- 3. Cria uma tabela sequencial de índices de 1 a 50 para quebrar as palavras por caractere
    indices(idx) AS (
        SELECT 1
        UNION ALL
        SELECT idx + 1 FROM indices WHERE idx < 50
    ),
    -- 4. Quebra a palavra ALVO caractere por caractere e conta a frequência de cada letra
    letras_alvo AS (
        SELECT 
            SUBSTR(alvo_upper, idx, 1) AS letra,
            COUNT(*) AS qtd
        FROM contexto, indices
        WHERE idx <= LENGTH(alvo_upper)
        GROUP BY SUBSTR(alvo_upper, idx, 1)
    ),
    -- 5. Quebra cada palavra CANDIDATA caractere por caractere e conta a frequência de cada letra
    letras_candidatas AS (
        SELECT 
            cand_idx,
            SUBSTR(cand_upper, idx, 1) AS letra,
            COUNT(*) AS qtd
        FROM lista_candidatas, indices
        WHERE idx <= LENGTH(cand_upper)
        GROUP BY cand_idx, SUBSTR(cand_upper, idx, 1)
    ),
    -- 6. Filtra os candidatos válidos avaliando se os mapas de letras batem perfeitamente
    candidatos_validos AS (
        SELECT lc.cand_idx, lc.cand_original
        FROM lista_candidatas lc, contexto ctx
        -- Regra 1: O comprimento das palavras deve ser idêntico
        WHERE LENGTH(lc.cand_upper) = LENGTH(ctx.alvo_upper)
          -- Regra 2: Palavras idênticas (case-insensitive) NÃO são anagramas
          AND lc.cand_upper != ctx.alvo_upper
          -- Regra 3: Garante que nenhuma letra intrusa ou contagem errada passe
          AND NOT EXISTS (
              -- Busca se a candidata tem alguma letra que não bate com a quantidade da palavra alvo
              SELECT 1 
              FROM letras_candidatas l_c
              LEFT JOIN letras_alvo l_a ON l_c.letra = l_a.letra
              WHERE l_c.cand_idx = lc.cand_idx
                AND (l_a.letra IS NULL OR l_c.qtd != l_a.qtd)
          )
        ORDER BY lc.cand_idx ASC
    )
    -- 7. Agrupa as palavras aprovadas de volta em um array JSON plano, retornando [] se vazio
    SELECT COALESCE(json_group_array(cand_original), '[]')
    FROM candidatos_validos
);