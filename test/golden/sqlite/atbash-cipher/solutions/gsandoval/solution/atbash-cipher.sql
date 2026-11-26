-- Schema: CREATE TABLE "atbash-cipher" (
--           property TEXT NOT NULL,
--           phrase   TEXT NOT NULL,
--           result   TEXT
--         );
-- Task: update the atbash-cipher table and set the result based on
--       property and phrase
WITH RECURSIVE
input_string AS (
    SELECT
        rowid AS id,
        phrase AS istring
    FROM "atbash-cipher"
    WHERE property = 'encode'
),
input_coded AS (
    SELECT
        rowid AS id,
        phrase AS icoded
    FROM "atbash-cipher"
    WHERE property = 'decode'
),
aphabet_data AS (
    SELECT 'abcdefghijklmnopqrstuvwxyz' AS aphabet
),
aphabet_explode_data (chr, indx, inv_indx) AS (
    SELECT
        SUBSTR(aphabet, 1, 1),
        1,
        LENGTH(aphabet)
    FROM aphabet_data

    UNION ALL

    SELECT
        SUBSTR(a.aphabet, e.indx + 1, 1),
        e.indx + 1,
        e.inv_indx - 1
    FROM aphabet_explode_data AS e
    CROSS JOIN aphabet_data AS a
    WHERE e.indx < LENGTH(a.aphabet)
),
map_data AS (
    SELECT
        a.chr AS ichar,
        b.chr AS coded
    FROM aphabet_explode_data AS a
    INNER JOIN aphabet_explode_data AS b
        ON a.indx = b.inv_indx

    UNION ALL

    SELECT
        SUBSTR('0123456789', indx, 1) AS ichar,
        SUBSTR('0123456789', indx, 1) AS coded
    FROM aphabet_explode_data
    WHERE indx <= 10
),
-- Posiciones para extraer los caracteres de cada frase.
positions (pos) AS (
    SELECT 1

    UNION ALL

    SELECT pos + 1
    FROM positions
    WHERE pos < (
        SELECT MAX(LENGTH(phrase))
        FROM "atbash-cipher"
    )
),
encoding_s1 AS (
    SELECT
        i.id,
        SUBSTR(LOWER(i.istring), p.pos, 1) AS ichar,
        p.pos
    FROM input_string AS i
    INNER JOIN positions AS p
        ON p.pos <= LENGTH(i.istring)
),
encoding_s2 AS (
    SELECT
        e.id,
        e.ichar,
        m.coded,
        e.pos
    FROM encoding_s1 AS e
    INNER JOIN map_data AS m
        ON e.ichar = m.ichar
),
encoding_s3 AS (
    SELECT
        id,
        ichar,
        coded,
        ROW_NUMBER() OVER (
            PARTITION BY id
            ORDER BY pos
        ) AS indx
    FROM encoding_s2
),
encoding_s4 (id, n, coded_str) AS (
    SELECT
        id,
        1,
        coded
    FROM encoding_s3
    WHERE indx = 1

    UNION ALL

    SELECT
        latest_table.id,
        latest_table.n + 1,
        latest_table.coded_str ||
        CASE
            WHEN ((latest_table.n + 1) % 5) = 0
                THEN s3.coded || ' '
            ELSE s3.coded
        END
    FROM encoding_s4 AS latest_table
    INNER JOIN encoding_s3 AS s3
        ON s3.id = latest_table.id
       AND s3.indx = latest_table.n + 1
),
encoding_result AS (
    SELECT
        s4.id,
        TRIM(s4.coded_str) AS coded
    FROM encoding_s4 AS s4
    WHERE s4.n = (
        SELECT MAX(n)
        FROM encoding_s4 AS r
        WHERE r.id = s4.id
    )
),
decoding_s1 AS (
    SELECT
        ic.id,
        SUBSTR(ic.icoded, p.pos, 1) AS coded_chr,
        p.pos
    FROM input_coded AS ic
    INNER JOIN positions AS p
        ON p.pos <= LENGTH(ic.icoded)
),
decoding_s2 AS (
    SELECT
        d.*,
        m.ichar AS decoded_chr
    FROM decoding_s1 AS d
    INNER JOIN map_data AS m
        ON m.coded = d.coded_chr
),
decoding_s3 AS (
    SELECT
        id,
        GROUP_CONCAT(decoded_chr, '') OVER (
            PARTITION BY id
            ORDER BY pos
            ROWS BETWEEN
                UNBOUNDED PRECEDING AND
                UNBOUNDED FOLLOWING
        ) AS decoded_str
    FROM decoding_s2
),
decoding_result AS (
    SELECT DISTINCT
        id,
        decoded_str AS decoded
    FROM decoding_s3
),
cipher_result AS (
    SELECT
        id,
        coded AS result
    FROM encoding_result

    UNION ALL

    SELECT
        id,
        decoded AS result
    FROM decoding_result
)
UPDATE "atbash-cipher"
SET result = COALESCE(
    (
        SELECT r.result
        FROM cipher_result AS r
        WHERE r.id = "atbash-cipher".rowid
    ),
    ''
)
WHERE property IN ('encode', 'decode');