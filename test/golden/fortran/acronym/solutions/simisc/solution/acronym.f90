module acronym
   implicit none

contains

   pure function abbreviate(s) result(a)
      character(len=*), intent(in) :: s
      character(len=len_trim(s)) :: a
      character :: letter
      integer :: idx_s, idx_a
      logical :: new_word

      new_word = .true.
      idx_a = 0

      do idx_s = 1, len_trim(s)
         letter = s(idx_s:idx_s)

         if (letter == ' ' .or. letter == '-') then
            new_word = .true.
            cycle
         end if

         if (.not. new_word) cycle

         if ('a' <= letter .and. letter <= 'z') then
            letter = achar(ichar(letter) - ichar('a') + ichar('A'))
         end if

         if ('A' <= letter .and. letter <= 'Z') then
            idx_a = idx_a + 1
            a(idx_a:idx_a) = letter
            new_word = .false.
         end if
      end do

      a = a(1:idx_a)
   end function abbreviate

end module acronym
