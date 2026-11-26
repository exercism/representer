-- Schema: CREATE TABLE "armstrong-numbers" ("number" INT, "result" BOOLEAN);
-- Task: update the armstrong-numbers table and set the result based on the number field.
UPDATE "armstrong-numbers"
SET result = (
    -- Calcular la suma de cada dígito elevado a la potencia de la cantidad de dígitos
    SELECT SUM(POWER(CAST(SUBSTR(number_text, i, 1) AS INT), digit_count))
    FROM (
        -- Convertir el número a texto y contar los dígitos
        SELECT CAST(number AS TEXT) AS number_text, LENGTH(CAST(number AS TEXT)) AS digit_count
    ), (
        -- Generar índices de los dígitos
        SELECT 1 AS i UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
    )
    WHERE i <= digit_count -- Limitar el cálculo a la cantidad de dígitos del número
) = number; -- Comparar con el número original
