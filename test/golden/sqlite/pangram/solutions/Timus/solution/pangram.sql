UPDATE pangram SET result = (
    WITH chars(c) AS (
        SELECT upper(substr(sentence, value, 1))
        FROM generate_series(1, length(sentence))
    )
    SELECT COUNT(DISTINCT c) = 26 FROM chars WHERE c GLOB '[A-Z]'
);
