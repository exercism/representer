namespace PalindromeProducts

structure Factors where
  a : Nat
  b : Nat
  h : a ≤ b
  deriving BEq, Repr

structure Result where
  product : Nat
  factors : List Factors
  deriving BEq, Repr

private def isPalindrome (n : Nat) : Bool :=
  let digits := Nat.toDigits 10 n
  digits == List.reverse digits

def smallest (min max : Nat) (_h₀ : min ≤ max) : Option Result := do
  let mut product: Option Nat := none
  let mut factors: List Factors := []
  for a in [min : max + 1] do
    for h_memb : b in [a : max + 1] do
      let h : a ≤ b := h_memb.left  -- `h_memb` is roughly `a ≤ b ∧ b < max+1`
      let p := a * b
      if product.elim false (· < p) then
        break     -- no need to check bigger `b`, cut this branch
      if !isPalindrome p then
        continue
      if product.elim true (· > p) then
        product := some p
        factors := [⟨ a, b, h ⟩]
      else if product.elim false (· == p) then
        factors := ⟨ a, b, h ⟩ :: factors
  return ⟨ <-product, factors ⟩

def largest (min max : Nat) (_h₀ : min ≤ max) : Option Result := do
  let mut product: Option Nat := none
  let mut factors: List Factors := []
  let mut a := max
  while min <= a do
    let mut b := max + 1
    repeat do
      b := b - 1
      if h_b : a ≤ b then   -- the typechecker is unhappy with mutable `b` in while
        let p := a * b
        if product.elim false (· > p) then
          break     -- no need to check smaller `b`, cut this branch
        if !isPalindrome p then
          continue
        if product.elim true (· < p) then
          product := some p
          factors := [⟨ a, b, h_b ⟩]
        else if product.elim false (· == p) then
          factors := ⟨ a, b, h_b ⟩ :: factors
      else break
    a := a - 1
  return ⟨ <-product, factors ⟩

end PalindromeProducts
