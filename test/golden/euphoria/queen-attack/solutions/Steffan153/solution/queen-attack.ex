include std/math.e

public type queen(sequence position)
  return length(position) = 2 and sum(0 <= position and position <= 7) = 2
end type

public function can_attack(queen white_queen, queen black_queen)
  return abs(white_queen[1] - black_queen[1]) = abs(white_queen[2] - black_queen[2]) or sum(white_queen = black_queen) > 0
end function
