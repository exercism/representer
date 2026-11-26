module hamming
  implicit none
contains

  function compute(strand1, strand2, distance)
      character(*) :: strand1, strand2
      integer :: distance
      logical :: compute
      integer :: i

      distance = 0
      compute = .false.

      if (len_trim(strand1) /= len_trim(strand2)) then
          return
      end if

      compute = .true.
      do i = 1, len_trim(strand1)
          if (strand1(i:i) /= strand2(i:i)) then
              distance = distance - 1
          end if
      end do

  end function compute

end module hamming
