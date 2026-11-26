-- Schema: CREATE TABLE IF NOT EXISTS "all-your-base" (
--           input_base  INTEGER NOT NULL,
--           digits      TEXT    NOT NULL,  -- json array
--           output_base INTEGER NOT NULL,
--           result      TEXT               -- json object
--         );
-- Task: update the all-your-base table and set the result based on converting
--       digits from input_base to output_base.
--       * the digits column contains a JSON-encoded list of integers.
--       * the result column should contain JSON-encoded data: an
--         object with the digits as integers or a descripition of any errors.
UPDATE "all-your-base" AS t
SET result = CASE
    WHEN t.input_base < 2 THEN
        json_object('error', 'input base must be >= 2')

    WHEN t.output_base < 2 THEN
        json_object('error', 'output base must be >= 2')

    WHEN EXISTS (
        SELECT 1
        FROM json_each(t.digits) AS d
        WHERE d.value < 0 OR d.value >= t.input_base
    ) THEN
        json_object(
            'error',
            'all digits must satisfy 0 <= d < input base'
        )

    ELSE (
        WITH RECURSIVE
        -- Convierte a decimal, leyendo de izquierda a derecha.
        base_10(pos, decimal_n) AS (
            SELECT 0, 0

            UNION ALL

            SELECT
                pos + 1,
                decimal_n * t.input_base
                    + json_extract(t.digits, '$[' || pos || ']')
            FROM base_10
            WHERE pos < json_array_length(t.digits)
        ),

        -- Convierte a la base de salida mediante divisiones.
        base_n(residual, coded) AS (
            SELECT decimal_n, ''
            FROM base_10
            WHERE pos = json_array_length(t.digits)

            UNION ALL

            SELECT
                residual / t.output_base,
                CAST(residual % t.output_base AS TEXT)
                    || CASE
                        WHEN coded = '' THEN ''
                        ELSE ',' || coded
                       END
            FROM base_n
            WHERE residual > 0
        )

        SELECT json_object(
            'digits',
            json(
                '['
                || CASE WHEN coded = '' THEN '0' ELSE coded END
                || ']'
            )
        )
        FROM base_n
        WHERE residual = 0
    )
END;