def ciphertext (plaintext: []u8): []u8 =
  -- Step 1: Normalize the text - keep only alphanumeric and convert to lowercase
  let normalized = plaintext 
    |> filter (\c -> (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
    |> map (\c -> if c >= 'A' && c <= 'Z' then c + ('a' - 'A') else c)
  
  let n = length normalized
  
  -- If empty after normalization, return empty
  in if n == 0 then []
     else
       -- Step 2: Calculate rectangle dimensions
       -- c should be the smallest integer where c >= ceil(sqrt(n))
       let sqrt_n = f32.sqrt (f32.i64 n)
       let c = i64.f32 (f32.ceil sqrt_n)
       let r = (n + c - 1) / c  -- ceiling division: ceil(n/c)
       
       -- Step 3: Create rectangle filled row-by-row, pad with spaces if needed
       let total_size = r * c
       let rectangle = tabulate total_size (\i ->
         if i < n then normalized[i] else ' ')
       
       -- Step 4: Read column-by-column and format as space-separated chunks
       let cipher_chars = flatten (tabulate c (\col ->
         let column = tabulate r (\row -> rectangle[row / c + col])
         in column ++ [' ']))  -- Add space after each chunk
       
       -- Remove the trailing space
       in cipher_chars[:length cipher_chars - 1]
             