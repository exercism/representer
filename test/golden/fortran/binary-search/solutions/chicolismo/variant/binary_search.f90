module binary_search
   implicit none
   
contains

   function find(ary, val) result(idx)
      integer, intent(in) :: ary(:), val
      integer :: idx, i, min, max, current
      idx = -1
      min = 1
      max = size(ary)
      do while (min <= max)
         i = (max - min) / 2 + min
         current = ary(i)
         if (current == val) then
            idx = i
            exit
         elseif (current < val) then
            min = i + 1
         else
            max = i + 1
         end if
      end do
   end function find

end module
