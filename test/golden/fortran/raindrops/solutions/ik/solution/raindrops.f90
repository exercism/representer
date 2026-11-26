module raindrops
  implicit none
contains

  function convert(i)
    integer, parameter :: n = 3
    integer :: i, j, offset
    character(20) :: convert
    integer, dimension(n) :: divisors = [3, 5, 7]
    character(len=5), dimension(n) :: strings = ["Pling", "Plang", "Plong"]

    offset = 1
    do j = 1, n
      if (mod(i, divisors(j)) == 0) then
        convert(offset:) = strings(j)
        offset = offset + len(strings(j))
      end if
    end do

    if (offset == 1) write(convert, '(i0)') i
  end function convert

end module raindrops
