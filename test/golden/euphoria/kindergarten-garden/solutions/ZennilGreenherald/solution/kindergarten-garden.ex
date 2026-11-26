include std/sequence.e

function to_plant(atom p)
  if p = 'G' then return "grass"
  elsif p = 'C' then return "clover"
  elsif p = 'R' then return "radishes"
  elsif p = 'V' then return "violets"
  end if
end function

public function plants(sequence garden, sequence student)
 integer column = (student[1] - 'A') * 2 + 1
 sequence lines = split(garden, "\n")
 return { to_plant(lines[1][column]), to_plant(lines[1][column + 1]), to_plant(lines[2][column]), to_plant(lines[2][column + 1]) }
end function
