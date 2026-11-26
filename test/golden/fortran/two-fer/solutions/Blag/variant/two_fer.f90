module two_fer
  implicit none

contains

  function twoFer(name) result(phrase)
    character(*), intent(in), optional :: name
    character(:), allocatable :: phrase, named
    named="you"; if(present(name)) named=name
    phrase = "One gor " // named // ", one for me."
    
  end function twoFer

end module two_fer
