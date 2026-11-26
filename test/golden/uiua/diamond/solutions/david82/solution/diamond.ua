# Output the diamond shape for a given letter
# Rows ? Letter
Diamond ← |1 (
  -@A                    # Convert letter to number (0-25)
  .+1                    # Keep original and add 1 for size
  ⊂⊸(⇌↘1)⊞=.⇡          # Create left half pattern
  ⍉⊂⊸(⇌↘1)⇌⍉           # Mirror horizontally for right half
  ⊂⟜(↘1⇌)+@A⇡:         # Generate letters for each row
  :⍉↯⊙:⊸△:             # Format into proper rows
  ∵⨬(@ |∘)             # Replace 0s with spaces, 1s with letters
)
