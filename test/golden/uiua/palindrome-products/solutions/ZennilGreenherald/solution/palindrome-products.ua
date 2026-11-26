ShapeNil      ← ⨬(∘|↯0_3) ⊸(=0⧻)
InclRange     ← + ⟜(⇡ +1 -)
ProdsAndPairs ← ⊸≡/× ⧅≤ 2 InclRange
IsPal         ← ≍⊸⇌°⋕
SelBoth       ← ∩⌞⊏ ⊚

# Find the smallest palindrome product of two numbers in a range
# PalindromeProducts ? Min Max
Smallest ← |2 ⨬(ShapeNil ⍉ ⊂ ⊙⍉ SelBoth ⊸= ⊸/↧ SelBoth ⊸(≡IsPal) ProdsAndPairs|"invalid range"◌◌) ◡<

# Find the largest palindrome product of two numbers in a range
# PalindromeProducts ? Min Max
Largest ← |2 ⨬(ShapeNil ⍉ ⊂ ⊙⍉ SelBoth ⊸= ⊸/↥ SelBoth ⊸(≡IsPal) ProdsAndPairs|"invalid range"◌◌) ◡< 
