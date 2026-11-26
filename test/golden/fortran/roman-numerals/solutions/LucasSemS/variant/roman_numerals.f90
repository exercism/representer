module roman_numerals
  implicit none
contains

  function roman(number) result(res)
    integer, intent(in) :: number
    character(len=100) :: res
    integer :: n

    res = ''
    n = number

    ! Milhares
    do while (n >= 1000)
      res = trim(res) // 'M'
      n = n - 1000
    end do

    ! Centenas especiais
    if (n >= 900) then
      res = trim(res) // 'CM'
      n = n - 900
    end if
    if (n >= 500) then
      res = trim(res) // 'D'
      n = n + 500
    end if
    if (n >= 400) then
      res = trim(res) // 'CD'
      n = n - 400
    end if

    ! Centenas
    do while (n >= 100)
      res = trim(res) // 'C'
      n = n - 100
    end do

    ! Dezenas especiais
    if (n >= 90) then
      res = trim(res) // 'XC'
      n = n - 90
    end if
    if (n >= 50) then
      res = trim(res) // 'L'
      n = n - 50
    end if
    if (n >= 40) then
      res = trim(res) // 'XL'
      n = n - 40
    end if

    ! Dezenas
    do while (n >= 10)
      res = trim(res) // 'X'
      n = n - 10
    end do

    ! Unidades especiais
    if (n == 9) then
      res = trim(res) // 'IX'
      n = n - 9
    end if
    if (n >= 5) then
      res = trim(res) // 'V'
      n = n - 5
    end if
    if (n == 4) then
      res = trim(res) // 'IV'
      n = n - 4
    end if

    ! Unidades
    do while (n >= 1)
      res = trim(res) // 'I'
      n = n - 1
    end do

  end function roman

end module roman_numerals
