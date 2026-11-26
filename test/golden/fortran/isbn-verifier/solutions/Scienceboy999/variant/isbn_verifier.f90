module isbn_verifier
  implicit none

contains

  function isValid(isbn) result(valid)
    character(*), intent(in) :: isbn
    logical :: valid
    integer i,d,total
    total = 0
    d = 10
    do i = 1, len(isbn)
      if((isbn(i:i).eq.' ').or.(isbn(i:i).eq.'-'))then
      else
        if((isbn(i:i).eq.'X'))then
          if(d.eq.1)then
            total = total + 10
            d = d + 1
          else
            valid = .false.
            return
          end if
        else
          if((isbn(i:i).ge.'0').and.(isbn(i:i).le.'9'))then
            total = total + (ichar(isbn(i:i)) - ichar('0')) * d
            d = d -1
          else
            valid = .false.
            return
          end if
        end if
      end if
    end do
    if(d.ne.0)then
      valid = .false.
      return
    end if

    valid = modulo(total,11).eq.0
  end function isValid

end module isbn_verifier
