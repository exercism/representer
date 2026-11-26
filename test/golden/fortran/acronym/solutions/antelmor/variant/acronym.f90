
module acronym
  implicit none
contains

  function abbreviate(s)
    character(len=*), intent(in) :: s
    character(len=len_trim(s)) :: abbreviate
    character :: past
    integer :: i, j

    j = 1
    past = '-'
    abbreviate = ''
    do i=1, len_trim(s)
      if (past == '-' .or. past == ' ') then
        if (s(i:i) >= 'a' .and. s(i:i) <= 'z') then
          abbreviate(j:j) = achar(iachar(s(i:i)) - 32)
          j = j + 1
        else if (s(i:i) > 'A' .and. s(i:i) <= 'Z') then
          abbreviate(j:j) = s(i:i)
          j = j + 1
        else if (s(i:i) /= '-' .and. s(i:i) /= ' ') then
          cycle
        end if
      end if
      past = s(i:i)
    end do
    
  end function

end module
