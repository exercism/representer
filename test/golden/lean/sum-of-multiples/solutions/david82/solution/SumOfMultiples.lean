namespace SumOfMultiples

/-- Mark every `n`, `n+fac`, … that is `< limNat`. Uses `Nat` stepping so arithmetic cannot overflow. -/
private partial def markStride (marks : Array Bool) (fac limNat : Nat) (n : Nat) : Array Bool :=
  if n < limNat then
    markStride (marks.setIfInBounds n true) fac limNat (n + fac)
  else
    marks

/-- Sum indices `i` with `marks[i] == true`. -/
private def sumMarked (marks : Array Bool) : UInt64 :=
  Nat.foldTR marks.size (fun i hi acc =>
    if marks[i]'hi then acc + UInt64.ofNat i else acc) 0

def sum (factors : List UInt64) (limit : UInt64) : UInt64 :=
  let limNat := limit.toNat
  if limNat == 0 then 0
  else
    let marks0 := Array.replicate limNat false
    let marks :=
      factors.foldl
        (fun marks f =>
          if f == 0 then marks.setIfInBounds 0 true
          else
            let fac := f.toNat
            -- `UInt64` factor was non-zero ⇒ `fac > 0`
            if fac == 0 then marks else markStride marks fac limNat fac)
        marks0
    sumMarked marks

end SumOfMultiples
