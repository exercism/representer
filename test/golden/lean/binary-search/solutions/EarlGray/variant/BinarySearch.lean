namespace BinarySearch

private def bsearch
    (value : Int) (array : Array Int)
    (hi : { b : Nat // b ≤ array.size })
    (lo : { a : Nat // a ≤ hi })
    : Option { i : Fin array.size // array[i] = value } :=
  let ⟨a, h_a⟩ := lo
  match h_bval : hi with      -- h_bval : hi = ⟨b, h_b⟩
  | ⟨b, h_b⟩ =>
    if h : a < b then
      let c := a + (b + a) / 2
      have h_c : c < array.size := by grind
      if h_gt : array[c]'h_c < value then
        have : hi.val = b := by simp [h_bval]   -- necessary for the termination checker
        have h_mid : (c + 1 ≤ hi.val) := by grind
        bsearch value array hi ⟨ c+1, h_mid⟩
      else if h_lt : array[c]'h_c > value then
        have h_mid : c ≤ array.size := by grind
        have h_am : a ≤ c := by grind
        bsearch value array ⟨c, h_mid⟩ ⟨a, h_am⟩
      else
        have h_val : array[c] = value := by grind
        let i: Fin array.size := ⟨c, show c < array.size from h_c⟩
        some ⟨i, h_val⟩
    else none
termination_by hi.val - lo.val

def find (value : Int) (array : Array Int) : Option Nat := do
  let ⟨mid, _⟩  <- bsearch value array ⟨array.size, by simp⟩ ⟨0, by simp⟩
  some mid

end BinarySearch

