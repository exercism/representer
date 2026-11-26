module raindrops
  implicit none
contains

  function convert(i)
    integer :: i
    ! don't preallocate convert, let it grow as needed
    character(:), allocatable :: convert

    if (mod(i, 3) == 0) then
      convert = 'Pling'
    end if

    if (mod(i, 5) == 0) then
      convert = convert // 'Plang'
    end if

    if (mod(i, 7) == 0) then
      convert = convert // 'Plong'
    end if

    if (len_trim(convert) == 0) then
      allocate(character(len=20) :: convert)
      write(convert, '(i0)') i
    end if

  end function convert

end module raindrops
