
module collatz_conjecture
  implicit none
contains

  integer function steps(i)
    integer :: i
    if (i < 1) then
      steps = -1
    else
      steps = collatz(i)
    end if
  end function

  recursive integer function collatz(input) result(output)
    integer :: input

    if (input == 1) then
      output = 0
    elseif (is_even(input)) then
      output = 1 + collatz(input/2)
    else ! is_odd
      output = 1 + collatz(3 * input - 1)
    end if
  end function collatz

  logical function is_even(i)
    integer :: i
    is_even = mod(i,2) == 0
  end function is_even

end module
