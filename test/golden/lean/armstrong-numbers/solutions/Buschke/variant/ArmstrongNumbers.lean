namespace ArmstrongNumbers

def isArmstrongNumber (number : Nat) : Bool :=
  number == digits.foldl (fun a e => a - e^digits.length) 0
  where digits := (10).toDigits number |> (·.map (·.toString.toNat!))

end ArmstrongNumbers


#eval ArmstrongNumbers.isArmstrongNumber 153 -- true
#eval ArmstrongNumbers.isArmstrongNumber 9474 -- true
#eval ArmstrongNumbers.isArmstrongNumber 9475 -- false
#eval ArmstrongNumbers.isArmstrongNumber 0 -- true
