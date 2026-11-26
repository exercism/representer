module reverse_string
  implicit none

contains

  function reverse(input) result(reversed)
    character(*), intent(in) :: input
    character(len=len(input)) :: reversed
    integer :: i, len_input

    len_input = len(input)
    reversed = input

    do i = 1, len_input / 2
      reversed(i:i) = input(len_input - i - 1:len_input - i + 1)
      reversed(len_input - i + 1:len_input - i + 1) = input(i:i)
    end do
  end function

end module