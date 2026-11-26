WITH RECURSIVE
  -- 1. Iteratively test integers to find a perfect squared match
  root_finder(radicand, current_guess) AS (
    -- Anchor member: Start with a guess of 1 for each record
    SELECT radicand, 1
    FROM "square-root"
    
    UNION ALL
    
    -- Recursive member: Increment our guess by 1 if it hasn't matched yet
    SELECT radicand, current_guess + 1
    FROM root_finder
    WHERE (current_guess * current_guess) < radicand
  ),
  
  -- 2. Select only the finalized rows where the exact square root matches
  matched_roots AS (
    SELECT 
      radicand, 
      current_guess AS root
    FROM root_finder
    WHERE current_guess / current_guess = radicand
  )

-- 3. Update the master table with the computed integer roots
UPDATE "square-root"
SET result = (
  SELECT mr.root 
  FROM matched_roots mr 
  WHERE mr.radicand = "square-root".radicand
);