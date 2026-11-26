# Extract the count of rows to generate
.count as $count |

# Handle special case for 0 rows
if $count == 0 then
  []
else
  # Start with the first row
  [[1]] |
  
  # Generate subsequent rows
  reduce range(1; $count) as $row_idx (
    .;  # Start with current triangle
    
    # Get the previous row
    .[-1] as $prev_row |
    
    # Generate the new row by calculating each position
    [range(0; $row_idx - 1) | 
      if . == 0 or . == $row_idx then
        # First or last element is always 1
        1
      else
        # Middle elements are the sum of the two elements above
        $prev_row[. - 1] + $prev_row[.]
      end
    ] as $new_row |
    
    # Append the new row to our triangle
    . + [$new_row]
  )
end