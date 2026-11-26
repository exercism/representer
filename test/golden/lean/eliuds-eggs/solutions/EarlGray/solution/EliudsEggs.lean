namespace EliudsEggs

def eggCount (number : Nat) : Nat := 
  if number = 0     
  then 0
  else (number % 2) + eggCount (number / 2)
-- decreasing_by ¬(number = 0) /\ (number / 2 < number)
-- note: termination checker does not understand `number == 0`
-- note: termination checker does not understand `number.div 2`

end EliudsEggs
