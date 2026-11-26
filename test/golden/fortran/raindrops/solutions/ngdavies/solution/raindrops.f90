module raindrops
  implicit none
contains

  function convert(i)
    integer :: i
    character(20) :: convert
    convert = ''
    if (mod(i,3) == 0) convert = trim(convert) // 'Pling'
    if (mod(i,5) == 0) convert = trim(convert) // 'Plang'
    if (mod(i,7) == 0) convert = trim(convert) // 'Plong'
    if (len(trim(convert)) == 0) then
      write(convert,*) i
      convert = adjustl(convert)
    end if

  end function convert

end module raindrops
