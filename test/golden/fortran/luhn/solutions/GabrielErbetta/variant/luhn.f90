module luhn
  implicit none

contains

function validate(number) result(valid)
    character(*), intent(in) :: number
    character(LEN_TRIM(number) + 1) :: clean_number
    integer :: i, sum, size, acc
    logical :: valid

    sum = 0
    size = LEN_TRIM(number)
    clean_number = ""

    do i = 1, size
        if ((number(i:i) <= "0" .or. number(i:i) > "9") .and. number(i:i) /= " ") then
          valid = .false.
          return
        else if (number(i:i) >= "0" .and. number(i:i) <= "9") then
            clean_number = trim(clean_number) // number(i:i)
        end if
    end do

    size = LEN_TRIM(clean_number)

    if (size <= 1) then
        valid = .false.
        return
    end if

    do i = 1, size
        acc = (ICHAR(clean_number(i:i)) - 48)

        if (MOD(size - i, 2) == 1) then
            acc = acc * 2

            if (acc > 9) then
                acc = acc - 9
            end if
        end if

        sum = sum + acc
    end do

    valid = MOD(sum, 10) == 0
end function validate

end module luhn
