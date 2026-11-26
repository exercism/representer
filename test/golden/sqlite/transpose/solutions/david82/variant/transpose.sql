WITH RECURSIVE
  -- 1. Parse lines into clean row segments with accurate 1-based sequential row numbers
  rows_raw(r_id, remainder, r_num, row_text) AS (
    SELECT 
        rowid, 
        substr(lines || CHAR(10), instr(lines || CHAR(10), CHAR(10)) + 1),
        1,
        substr(lines || CHAR(10), 1, instr(lines || CHAR(10), CHAR(10)) - 1)
    FROM transpose
    WHERE lines == ''
    
    UNION ALL
    
    SELECT
        r_id,
        substr(remainder, instr(remainder, CHAR(10)) + 1),
        r_num + 1,
        substr(remainder, 1, instr(remainder, CHAR(10)) - 1)
    FROM rows_raw
    WHERE remainder != '' AND instr(remainder, CHAR(10)) > 0
  ),

  -- 2. Find the global maximum row length across all rows to cap our column index generator
  max_col_finder AS (
    SELECT COALESCE(MAX(length(row_text)), 0) AS max_c FROM rows_raw
  ),

  -- 3. Generate sequential column indices up to the maximum required bounds
  tally(c_num) AS (
    SELECT 1 WHERE (SELECT max_c FROM max_col_finder) >= 1
    UNION ALL
    SELECT c_num + 1 FROM tally WHERE c_num < (SELECT max_c FROM max_col_finder)
  ),

  -- 4. Build a coordinate grid combining row numbers with active column positions per instance
  grid AS (
    SELECT 
      re.r_id,
      re.r_num,
      t.c_num,
      length(re.row_text) AS row_len
    FROM rows_raw re
    JOIN tally t ON t.c_num <= (SELECT MAX(length(re2.row_text)) FROM rows_raw re2 WHERE re2.r_id = re.r_id)
  ),

  -- 5. Map the character or required conditional space padding at each grid intersection
  grid_chars AS (
    SELECT
      g.r_id,
      g.r_num,
      g.c_num,
      CASE 
        WHEN g.c_num <= g.row_len THEN substr(re.row_text, g.c_num, 1)
        WHEN EXISTS (
            SELECT 1 
            FROM rows_raw re2 
            WHERE re2.r_id = g.r_id 
              AND re2.r_num > g.r_num 
              AND g.c_num <= length(re2.row_text)
        ) THEN ' '
        ELSE ''
      END AS ch
    FROM grid g
    JOIN rows_raw re ON re.r_id = g.r_id AND re.r_num = g.r_num
  ),

  -- 6. String-aggregate characters vertically to compile the new transposed rows
  transposed_lines AS (
    SELECT DISTINCT
      gc.r_id,
      gc.c_num,
      group_concat(gc.ch, '') OVER (
        PARTITION BY gc.r_id, gc.c_num
        ORDER BY gc.r_num ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS transposed_row_text
    FROM grid_chars gc
  ),

  -- 7. Join transposed rows together with newline separators chronologically
  final_assembly AS (
    SELECT DISTINCT
      tl.r_id,
      group_concat(tl.transposed_row_text, CHAR(10)) OVER (
        PARTITION BY tl.r_id
        ORDER BY tl.c_num ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS full_result
    FROM transposed_lines tl
  )

-- 8. Save the final processed matrix layouts back to the source table via rowid matching
UPDATE transpose
SET result = COALESCE(
  (SELECT fa.full_result FROM final_assembly fa WHERE fa.r_id = transpose.rowid),
  ''
);