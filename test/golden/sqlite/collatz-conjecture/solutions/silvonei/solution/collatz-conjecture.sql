-- Schema: CREATE TABLE "collatz" ("number" INTEGER, "steps" INTEGER);
-- Task: update the collatz table and set the steps based on the number.
UPDATE collatz
SET steps = (
    WITH RECURSIVE
    -- 1. Captura e isola as variáveis locais do registro atual usando rowid
    contexto AS (
        SELECT 
            number AS num_alvo
        FROM collatz AS sub
        WHERE sub.rowid = collatz.rowid
    ),
    -- 2. Laço recursivo que aplica as regras matemáticas da conjectura passo a passo
    sequencia(passo, valor_corrente) AS (
        SELECT 0, num_alvo 
        FROM contexto
        WHERE num_alvo > 0 -- Só inicia o loop se for um número natural válido
        
        UNION ALL
        
        SELECT 
            passo + 1,
            -- Se o valor for par: divide por 2. Se for ímpar: multiplica por 3 e soma 1.
            IIF(valor_corrente % 2 = 0, valor_corrente / 2, (valor_corrente * 3) + 1)
        FROM sequencia
        -- O laço continua rodando enquanto o valor gerado não chegar a 1
        WHERE valor_corrente > 1
    )
    -- 3. Seleciona o maior passo alcançado (o topo da pirâmide recursiva)
    SELECT 
        CASE 
            -- Validação de erro estrita para números menores ou iguais a zero
            WHEN (SELECT num_alvo FROM contexto) <= 0 THEN 1 / 0
            ELSE (SELECT passo FROM sequencia ORDER BY passo DESC LIMIT 1)
        END
);