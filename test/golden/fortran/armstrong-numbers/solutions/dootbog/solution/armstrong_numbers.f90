
module armstrong_numbers
  implicit none
contains

  logical function isArmstrongNumber(i)
    integer, intent(in) :: i
    integer :: j, acc
    
    isArmstrongNumber = .false.

    if (i .lt. 0) then
      return
    end if

    if (i .ge. 0 .and. i .lt. 10) then
      isArmstrongNumber = .true.
      return
    end if

    acc = 0
    j   = i
    do while (j .gt. 0)
      acc = acc + mod(j, 10) ** floor(log10(real(i)) + 1)
      j = j / 10
    end do

    isArmstrongNumber = i .eq. acc

  end function

end module
