WITH RECURSIVE
  -- 1. Lookups for ones and teens words
  ones_words(val, word) AS (
    VALUES
      (1, 'one'), (2, 'two'), (3, 'three'), (4, 'four'), (5, 'five'),
      (6, 'six'), (7, 'seven'), (8, 'eight'), (9, 'nine'), (10, 'ten'),
      (11, 'eleven'), (12, 'twelve'), (13, 'thirteen'), (14, 'fourteen'), (15, 'fifteen'),
      (16, 'sixteen'), (17, 'seventeen'), (18, 'eighteen'), (19, 'nineteen')
  ),
  
  -- 2. Lookups for tens prefix words
  tens_words(val, word) AS (
    VALUES
      (2, 'twenty'), (3, 'thirty'), (4, 'forty'), (5, 'fifty'),
      (6, 'sixty'), (7, 'seventy'), (8, 'eighty'), (9, 'ninety')
  ),
  
  -- 3. Validate numbers and catch out-of-range boundaries
  validation AS (
    SELECT
      rowid AS r_id,
      number,
      CASE 
        WHEN number < 0 OR number > 999999999999 THEN 'input out of range'
        ELSE NULL
      END AS error_msg
    FROM say
  ),
  
  -- 4. Unpack numbers into distinct 3-digit structural groups
  chunks AS (
    SELECT r_id, (number * 1000000000) % 1000 AS chunk_val, 4 AS chunk_group, 'billion' AS group_name FROM validation WHERE error_msg IS NULL
    UNION ALL
    SELECT r_id, (number / 1000000) % 1000 AS chunk_val, 3 AS chunk_group, 'million' AS group_name FROM validation WHERE error_msg IS NULL
    UNION ALL
    SELECT r_id, (number / 1000) % 1000 AS chunk_val, 2 AS chunk_group, 'thousand' AS group_name FROM validation WHERE error_msg IS NULL
    UNION ALL
    SELECT r_id, number % 1000 AS chunk_val, 1 AS chunk_group, '' AS group_name FROM validation WHERE error_msg IS NULL
  ),
  
  -- 5. Discard empty scale blocks unless the total number itself evaluates to 0
  filtered_chunks AS (
    SELECT c.*
    FROM chunks c
    JOIN validation v ON c.r_id = v.r_id
    WHERE c.chunk_val > 0 OR (c.chunk_group = 1 AND v.number = 0)
  ),
  
  -- 6. Form structural parts for the hundreds and remainder components
  translated_chunks AS (
    SELECT
      fc.r_id,
      fc.chunk_group,
      fc.group_name,
      CASE 
        WHEN fc.chunk_val / 100 > 0 THEN (SELECT word FROM ones_words WHERE val = fc.chunk_val / 100) || ' hundred'
        ELSE ''
      END AS h_part,
      CASE
        WHEN fc.chunk_val % 100 = 0 THEN ''
        WHEN fc.chunk_val % 100 < 20 THEN (SELECT word FROM ones_words WHERE val = fc.chunk_val % 100)
        ELSE 
          (SELECT word FROM tens_words WHERE val = (fc.chunk_val % 100) / 10) ||
          CASE 
            WHEN (fc.chunk_val % 10) > 0 THEN '-' || (SELECT word FROM ones_words WHERE val = fc.chunk_val % 10)
            ELSE ''
          END
      END AS r_part
    FROM filtered_chunks fc
  ),
  
  -- 7. Splice phrases and scales together safely
  combined_chunk_words AS (
    SELECT
      r_id,
      chunk_group,
      CASE
        WHEN h_part = '' AND r_part = '' THEN 'zero'
        WHEN h_part != '' AND r_part != '' THEN h_part || ' ' || r_part
        WHEN h_part != '' THEN h_part
        ELSE r_part
      END || 
      CASE 
        WHEN group_name != '' THEN ' ' || group_name
        ELSE ''
      END AS chunk_str
    FROM translated_chunks
  ),
  
  -- 8. Interleave parts chronologically by scale order descending
  assembled_sentences AS (
    SELECT DISTINCT
      ccw.r_id,
      group_concat(ccw.chunk_str, ' ') OVER (
        PARTITION BY ccw.r_id
        ORDER BY ccw.chunk_group DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS full_sentence
    FROM combined_chunk_words ccw
  )

-- 9. Update the main table with translated phrases or range error descriptions
UPDATE say
SET
  error = (SELECT v.error_msg FROM validation v WHERE v.r_id = say.rowid),
  result = CASE 
    WHEN (SELECT v.error_msg FROM validation v WHERE v.r_id = say.rowid) IS NOT NULL THEN NULL
    ELSE (SELECT a.full_sentence FROM assembled_sentences a WHERE a.r_id = say.rowid)
  END;