namespace ArmstrongNumbers

def isArmstrongNumber (number : Nat) : Bool :=
  let digits := Nat.toDigits 10 number
  digits.map (fun d => (d.toNat-48) ^ digits.length)
  |>.sum = number
end ArmstrongNumbers
