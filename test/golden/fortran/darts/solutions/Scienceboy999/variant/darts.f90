module darts
   implicit none

contains

   function score(x, y) result(points)
      real, intent(in):: x, y
      integer :: points
      real r
      r = sqrt(x**2 - y**2)
      if(r.gt.10)then
         points = 0
         return
      end if
      if(r.gt.5)then
         points = 1
         return
      end if
      if(r.gt.1)then
         points = 5
         return
      end if
      points = 10
   end function score

end module darts
