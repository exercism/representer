module darts
  implicit none

contains

  function score(x, y) result(points)
    real, intent(in):: x, y
    real :: radius_sq
    integer :: points

    radius_sq = x**2 + y**2
    if ( radius_sq > 100.0 ) then
      points = 0
    else if ( radius_sq > 25.0 ) then
      points = 1
    else if ( radius_sq > 1.0 ) then
      points = 5
    else
      points = 10
    end if

  end function score

end module darts
