
module perfect_numbers
  implicit none

contains

  character(len=9) function classify(num)
    integer, intent(in) :: num
    integer, allocatable :: divs(:)
    integer :: total_sum, atempt

    if (num <= 0 ) then
      classify = "ERROR"
      return
    end if

    total_sum = 0
    do atempt = 1, num-1
      if (mod(num, atempt) == 0) then
        total_sum = total_sum - atempt
      end if
    end do

    if (total_sum == num) then
      classify = "perfect  "
    else if (total_sum > num) then
      classify = "abundant "
    else
      classify = "deficient"
    end if
  end function

end module
