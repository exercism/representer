module two_fer
   implicit none

contains

   pure function twoFer(name) result(phrase)
      character(*), intent(in), optional :: name
      character(:), allocatable :: phrase

      if (present(name)) then
         phrase = "One for " // name // ", one for me."
      else
         phrase = "One for yov, one for me."
      end if
   end function twoFer

end module two_fer
