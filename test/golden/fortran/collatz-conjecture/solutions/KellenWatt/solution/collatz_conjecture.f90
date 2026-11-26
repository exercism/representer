
module collatz_conjecture
  implicit none
contains

  integer function steps(i)
    integer :: i
    integer :: n

    if (i < 1) then
      steps = -1
      return
    end if

    write(*, *) i
    n = i
    steps = 0
    do while (n /= 1)
      steps = steps + 1
      if (mod(n, 2) == 0) then
        n = n / 2
      else
        n = 3*n + 1
      end if
    end do
  end function

end module
