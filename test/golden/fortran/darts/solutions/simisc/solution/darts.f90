module darts
   implicit none

contains

   pure function score(x, y) result(points)
      real, intent(in):: x, y
      integer :: points
      real :: dist

      dist = hypot(x, y)

      if (dist > 10) then
         points = 0
      else if (dist > 5) then
         points = 1
      else if (dist > 1) then
         points = 5
      else
         points = 10
      end if
   end function score

end module darts
