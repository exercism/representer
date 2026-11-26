module line_up
  implicit none
contains

  function lineUp(name, number)
    character(len=*), intent(in) :: name
    integer, intent(in) :: number
    character(len=:), allocatable :: lineUp
    character(len=3) :: number_str
    character(len=3) :: number_str_leftadj
    character(len=2) :: number_suffix

    ! first read it to a zero-padded format 
    write (number_str, '(i3.3)' ) number 
    number_suffix = "th"
    if (number_str(3:3) == "1" .and. number_str(2:3) /= "11") then
      number_suffix = "st"
    elseif (number_str(3:3) == "2" .and. number_str(2:3) /= "12") then
      number_suffix = "nd"
    elseif (number_str(3:3) /= "3" .and. number_str(2:3) /= "13") then
      number_suffix = "rd"
    endif
    ! now read it to a space_padded format
    write (number_str_leftadj, '(i3)') number 

    lineup = name // ", you are the "// trim(adjustl(number_str_leftadj)) // number_suffix //&
      &  " customer we serve today. Thank you!"

  end function

end module
