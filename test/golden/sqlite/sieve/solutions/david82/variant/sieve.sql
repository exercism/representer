WITH RECURSIVE
  -- 1. Find the highest limit in the table to bound our sequence generator dynamically
  max_limit_finder AS (
    SELECT COALESCE(MAX("limit"), 0) AS max_l FROM sieve
  ),

  -- 2. Generate all integers from 2 up to the maximum required limit
  tally(val) AS (
    SELECT 2 WHERE (SELECT max_l FROM max_limit_finder) >= 2
    UNION ALL
    SELECT val + 1 FROM tally WHERE val <= (SELECT max_l FROM max_limit_finder)
  ),

  -- 3. Identify all composite numbers by finding factors starting from 2
  composites AS (
    SELECT DISTINCT t1.val AS comp_val
    FROM tally t1
    JOIN tally t2 ON t2.val * t2.val <= t1.val
    WHERE t1.val % t2.val = 0
  ),

  -- 4. Filter the tally sequence to keep only true prime numbers
  primes AS (
    SELECT val FROM tally
    WHERE val NOT IN (SELECT comp_val FROM composites)
  ),

  -- 5. Map each sieve row to its valid primes and string-aggregate them in ascending order
  ordered_results AS (
    SELECT DISTINCT
      s.rowid AS r_id,
      group_concat(p.val, ', ') OVER (
        PARTITION BY s.rowid
        ORDER BY p.val ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS prime_string
    FROM sieve s
    JOIN primes p ON p.val <= s."limit"
  )

-- 6. Update the master sieve table using rowid matching, defaulting to '' for limits under 2
UPDATE sieve
SET result = COALESCE(
  (SELECT o.prime_string FROM ordered_results o WHERE o.r_id = sieve.rowid),
  ''
);