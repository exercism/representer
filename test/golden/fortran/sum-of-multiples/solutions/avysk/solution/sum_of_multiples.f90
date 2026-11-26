module sum_of_multiples
   implicit none

contains

   function sum_multiples(factors, limit) result(res)
      integer, intent(in) :: factors(:), limit
      integer :: res
      integer :: idx, free, factor, cur
      ! list of found multiplies
      integer, dimension(:), allocatable :: mlist

      res = 0
      ! index of the next free cell in mlist
      free = 1
      ! very generous allocation
      allocate (mlist(limit))

      do idx = lbound(factors, dim=1), ubound(factors, dim=1)
         factor = factors(idx)
         if (factor == 0) then
            cycle
         end if
         cur = factor
         do while (cur < limit)
            if (.not. any(mlist(1:(free - 1)) == cur)) then
               ! we found new multiple, store it and add it to the sum
               mlist(free) = cur
               free = free + 1
               res = res + cur
            end if
            ! move to the next multiple
            cur = cur + factor
         end do
      end do

   end function sum_multiples

end module sum_of_multiples
