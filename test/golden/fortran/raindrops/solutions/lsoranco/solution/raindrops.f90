module raindrops
  implicit none
contains

  function convert(i)
    integer :: i
    character(20) :: convert
    logical :: any_factor

    any_factor = .FALSE.
    convert = ""

    if (mod(i, 3) == 0) then
      convert = trim(convert)//"Pling"
      any_factor = .TRUE.
    end if
    if (mod(i, 5) == 0) then
      convert = trim(convert)//"Plang"
      any_factor = .TRUE.
    end if
    if (mod(i, 7) == 0) then
      convert = trim(convert)//"Plong"
      any_factor = .TRUE.
    end if

    if (.not. any_factor) then
      write (convert, '(I0)') i
    end if

  end function convert

end module raindrops
