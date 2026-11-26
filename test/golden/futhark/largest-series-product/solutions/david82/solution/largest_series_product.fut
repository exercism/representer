let largest_product (digits: []u8) (span: i32) : i32 =
  -- Check for negative span
  if span < 0 then
    let _ = trace "negative span" in 0/0
  -- Check for span longer than string length
  else if span > i32.i64 (length digits) then
    let _ = trace "span too long" in 0/0
  -- Check for empty string with nonzero span
  else if length digits == 0 && span > 0 then
    let _ = trace "empty string with nonzero span" in 0/0
  -- Handle span of 0 (empty product)
  else if span == 0 then
    1
  else
    -- Validate that all characters are digits
    let valid_digits = map (\c -> c >= '0' && c <= '9') digits
    let all_valid = reduce (&&) true valid_digits
    in if not all_valid then
      let _ = trace "invalid character" in 0/0
    else
      -- Convert characters to integers
      let digit_values = map (\c -> i32.u8 (c - '0')) digits
      -- Calculate products of all spans
      let span_i64 = i64.i32 span
      let num_spans = length digits - span_i64 + 1
      let products = tabulate num_spans (\i ->
        let series = digit_values[i:i+span_i64]
        in reduce (*) 1 series
      )
      -- Return the maximum product
      in reduce i32.max 0 products
    