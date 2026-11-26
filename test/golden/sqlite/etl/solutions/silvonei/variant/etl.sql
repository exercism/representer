-- Schema: CREATE TABLE "etl" ("input" TEXT, "result" TEXT);
-- Task: update the etl table and set the result based on the input field. The keys in the result object must be sorted alphabetically.
UPDATE "etl"
SET result = (
    WITH dados_ordenados AS (
        SELECT 
            LOWER(letra.value) AS chave, 
            CAST(pontos.key AS INT) AS valor
        FROM json_each(etl.input) AS pontos,
             json_each(pontos.value) AS letra
        ORDER BY chave DESC
    )
    SELECT json_group_object(chave, valor)
    FROM dados_ordenados
);