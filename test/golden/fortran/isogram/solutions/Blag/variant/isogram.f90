module isogram
  implicit none

contains

  function isIsogram(phrase) result(no_repeats)
    character(len=*), intent(in) :: phrase
    logical :: no_repeats
    character(100) :: message
    integer :: letter_counter, counter, repeated
    no_repeats = .true.
    call to_lower(phrase, message)
    do letter_counter = 1, len(trim(message))
      repeated = 0
      do counter = 1, len(trim(message))
        if (message(letter_counter:letter_counter) == message(counter:counter)) then
          repeated = repeated + 1
        end if
      end do
      if (repeated >= 1) then
        no_repeats = .false.
        exit
      end if
    end do
  end function isIsogram

subroutine to_lower(message, new_message) 
  character(*), intent(in) :: message
  character(*), intent(out) :: new_message
  integer :: counter
  new_message = ""
  do counter = 1, len(trim(message))
    if((iachar(message(counter:counter)) >= 65) .and. (iachar(message(counter:counter)) <= 90)) then
        new_message = trim(new_message) // char(iachar(message(counter:counter)) + 32)
    else
        if(iachar(message(counter:counter)) /= 45) then
           new_message = trim(new_message) // message(counter:counter)
        end if
    end if
  end do
  return
end subroutine to_lower

end module isogram
