-- Schema:
-- CREATE TABLE "swift-scheduling" (
--     meeting_start    TEXT NOT NULL, -- datetime YYYY-MM-DDTHH:mm:ss
--     date_description TEXT NOT NULL,
--     result           TEXT           -- datetime YYYY-MM-DDTHH:mm:ss
-- );
--
-- Task: update swift-scheduling table and set the result based on the meeting_start and description.
UPDATE "swift-scheduling"
SET result = (
    WITH RECURSIVE
    -- 1. Captura estritamente a linha atual do UPDATE e limpa espaços ocultos das strings
    contexto_limpo AS (
        SELECT 
            meeting_start,
            TRIM(date_description) AS desc_limpa,
            CAST(STRFTIME('%Y', meeting_start) AS INT) AS ano_atual,
            CAST(STRFTIME('%m', meeting_start) AS INT) AS mes_atual
        FROM "swift-scheduling" AS s
        WHERE s.rowid = "swift-scheduling".rowid
    ),
    -- 2. Define o ano de destino e o mês de destino de forma isolada para M e Q
    parametros_alvo AS (
        SELECT 
            meeting_start,
            desc_limpa,
            CASE 
                -- Se contiver 'M' (ex: '11M')
                WHEN desc_limpa LIKE '%M' THEN CAST(REPLACE(desc_limpa, 'M', '') AS INT)
                -- Se contiver 'Q' (ex: 'Q3' -> mês 9)
                WHEN desc_limpa LIKE 'Q%' THEN CAST(REPLACE(desc_limpa, 'Q', '') AS INT) * 3
                ELSE NULL
            END AS mes_destino,
            CASE 
                WHEN desc_limpa LIKE '%M' THEN 
                    IIF(mes_atual >= CAST(REPLACE(desc_limpa, 'M', '') AS INT), ano_atual + 1, ano_atual)
                WHEN desc_limpa LIKE 'Q%' THEN 
                    IIF(mes_atual > CAST(REPLACE(desc_limpa, 'Q', '') AS INT) * 3, ano_atual + 1, ano_atual)
                ELSE NULL
            END AS ano_destino
        FROM contexto_limpo
    ),
    -- 3. Gera todos os dias válidos do mês alvo na memória do banco de dados
    calendario_mes(data_str, mes_limite) AS (
        SELECT 
            PRINTF('%04d-%02d-01', ano_destino, mes_destino),
            PRINTF('%02d', mes_destino)
        FROM parametros_alvo
        WHERE mes_destino IS NOT NULL
        
        UNION ALL
        
        SELECT DATE(data_str, '+1 day'), mes_limite
        FROM calendario_mes
        WHERE STRFTIME('%m', DATE(data_str, '+1 day')) = mes_limite
    ),
    -- 4. Isola de forma robusta e garantida o primeiro dia útil do mês
    primeiro_dia_util AS (
        SELECT data_str 
        FROM calendario_mes 
        WHERE STRFTIME('%w', data_str) NOT IN ('0', '6')
        ORDER BY data_str ASC
        LIMIT 1
    ),
    -- 5. Isola de forma robusta e garantida o último dia útil do mês
    ultimo_dia_util AS (
        SELECT data_str 
        FROM calendario_mes 
        WHERE STRFTIME('%w', data_str) NOT IN ('0', '6')
        ORDER BY data_str DESC
        LIMIT 1
    )
    -- 6. Seleciona o formato final baseando-se estritamente na string limpa
    SELECT 
        CASE 
            WHEN desc_limpa = 'NOW' THEN 
                STRFTIME('%Y-%m-%dT%H:%M:%S', datetime(meeting_start, '+2 hours'))
                
            WHEN desc_limpa = 'ASAP' THEN 
                STRFTIME('%Y-%m-%dT%H:%M:%S', datetime(meeting_start, 'start of day', IIF(TIME(meeting_start) <= '13:00:00', '+17 hours', '+37 hours')))
                
            WHEN desc_limpa = 'EOW' THEN 
                STRFTIME('%Y-%m-%dT%H:%M:%S', datetime(meeting_start, 'start of day', 
                    (IIF(STRFTIME('%w', meeting_start) IN ('1','2','3'), 137, 188) 
                    - CAST(STRFTIME('%w', meeting_start) AS INT) * 24) || ' hours'))
                    
            WHEN desc_limpa LIKE '%M' THEN 
                (SELECT data_str FROM primeiro_dia_util) || 'T08:00:00'
                
            WHEN desc_limpa LIKE 'Q%' THEN 
                (SELECT data_str FROM ultimo_dia_util) || 'T08:00:00'
        END
    FROM contexto_limpo
);