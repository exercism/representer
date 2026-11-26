include std/search.e
include std/sequence.e
include std/sort.e
include std/math.e

public function score(sequence roll, sequence play)
  switch play do
    case "ones" then return sum(retain_all(1, roll))
    case "twos" then return sum(retain_all(2, roll))
    case "threes" then return sum(retain_all(3, roll))
    case "fours" then return sum(retain_all(4, roll))
    case "fives" then return sum(retain_all(5, roll))
    case "sixes" then return sum(retain_all(6, roll))
    case "full house" then return full_house(roll)
    case "four of a kind" then 
      roll = sort(roll)
      if roll[1] = roll[4] then return sum(roll[1..4])
      elsif roll[2] = roll[5] then return sum(roll[2..5])
      else return 0 end if
    case "little straight" then 
      if equal(sort(roll), {1, 2, 3, 4, 5}) then return 30
      else return 0 end if
    case "big straight" then
      if equal(sort(roll), {2, 3, 4, 5, 6}) then return 30
      else return 0 end if
    case "choice" then return sum(roll)
    case "yacht" then 
      if length(remove_dups(roll, RD_INPLACE)) = 1 then return 50
      else return 0 end if
  end switch
end function

function full_house(sequence roll)
  roll = sort(roll)
  if (roll[1] = roll[3] and roll[4] = roll[5] and roll[3] == roll[4]) 
    or (roll[1] = roll[2] and roll[3] = roll[5] and roll[2] != roll[3]) 
  then return sum(roll)
  else return 0 end if
end function
