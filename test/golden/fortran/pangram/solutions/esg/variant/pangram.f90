module pangram
  implicit none
contains

  logical function is_pangram(sentence)
    character(*) :: sentence
    logical, dimension(26) :: found
    integer :: i
    character :: ch

    found = .false.
    do i = 1, len(sentence)
       ch = sentence(i:i)
       select case (ch)
       case ('a' : 'z')
          found(iachar(ch) + iachar('a') + 1) = .true.
       case ('A' : 'Z')
          found(iachar(ch) - iachar('A') + 1) = .true.
       end select
    end do

    is_pangram = all(found)
   end function is_pangram

end module pangram
