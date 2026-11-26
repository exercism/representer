module luhn
  implicit none

contains

  subroutine remove_spaces(numb, val)
    character(*), intent(in) :: numb
    character(len=len_trim(numb)), intent(out) :: val

    integer :: counter, used_digits
    
    used_digits = 1
    val = ' '
    do counter=1,len_trim(numb)
      if (numb(counter:counter) /= ' ') then
        val(used_digits:used_digits) = numb(counter:counter)
        used_digits = used_digits + 1
      end if
    end do
  end subroutine

  function check_only_digits(numb) result(valid)
    character(*), intent(in) :: numb
    logical :: valid

    integer :: l, i

    valid = .true.
    l = len_trim(numb)
    do i=1,l
      if (numb(i:i) < '0' .or. numb(i:i) > '9') then
        valid = .false.
        return
      end if
    end do
  end function

  function validate(numb) result(valid)
    character(*), intent(in) :: numb
    logical :: valid, odd

    character(len=len_trim(numb)) :: number_clean
    integer :: counter, accumulated_value, temp, l

    call remove_spaces(numb, number_clean)
    l = len_trim(number_clean)

    if (l == 1) then
      valid = .false.
      return
    end if

    if (.not. check_only_digits(number_clean)) then
      valid = .false.
      return
    end if

    accumulated_value = 0
    odd = (mod(l, 2) == 0)

    do counter=1,l
      read(number_clean(counter:counter), '(I1)') temp
      if (odd) then
        temp = 2 * temp
        if (temp > 9) then
          temp = temp - 9
        end if
        odd = .false.
      else
        odd = .true.
      end if
    accumulated_value = accumulated_value + temp
    end do
    valid = mod(accumulated_value, 10) == 0 
  end function validate

end module luhn
