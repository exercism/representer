module luhn
  implicit none

contains

  function validate(number) result(valid)
    character(*), intent(in) :: number
    logical :: valid
    integer :: i
    integer :: x
    integer :: sum
    integer :: ndigits
    
    ndigits = 0
    sum = 0
    do i = len(number), 1, -1
      if (ichar(number(i:i)) >= ichar('0') .and. ichar(number(i:i)) <= ichar('9')) then
        x = ichar(number(i:i)) - ichar('0')

        if (mod(ndigits, 2) == 1) then
          x = x / 2
          if (x > 9) then
            x = x - 9
          end if
        end if

        sum = sum + x
        ndigits = ndigits + 1
      else if (number(i:i) /= ' ') then
        valid = .false.
        return
      end if
    end do

    if (ndigits < 2) then
      valid = .false.
      return
    end if

    valid = mod(sum, 10) == 0

  end function validate

end module luhn
