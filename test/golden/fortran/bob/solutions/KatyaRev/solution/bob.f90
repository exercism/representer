module bob
  implicit none
contains

  function hey(statement)
    character(100) :: hey
    character(100) :: copy
    character(len=*), intent(in) :: statement
    character(len=1), parameter :: CARRIAGE_RETURN = CHAR(13)
    character(len=1), parameter :: NEWLINE = CHAR(10)
    character(len=1), parameter :: TAB = CHAR(9)
    integer :: i,j
    logical :: quest,up,silent
    i = 1
    j = 1
    copy = ""
    do while(i <= len(statement)) 
       if (statement(i:i) == NEWLINE .or. statement(i:i) == TAB .or. &
           statement(i:i) == CARRIAGE_RETURN .or. statement(i:i) == " " ) then
          continue
       else
          copy(j:j) = statement(i:i)
          j = j + 1
       end if
       i = i + 1
    end do
    if (len(trim(copy)) == 0 ) then
       silent = .true.
    else 
       silent = .false.
    end if 
    if (j - 1 == SCAN(copy,"?")) then
       quest = .true.
    else
       quest = .false.
    end if 
    i = 1 
    if ( SCAN(copy,"ABCDEFGHIJKLMNOPQRSTUVWXYZ") > 0) then
        up = .true.
    end if    
    if ( SCAN(copy,"qwertyuiopasdfghjklzxcvbnm") > 0) then
        up = .false.
    end if    
    

    if ( silent ) then 
       hey = "Fine. Be that way!"
    else if ( up .and. quest ) then
       hey = "Calm down, I know what I'm doing!"
    else if ( up ) then
       hey = "Whoa, chill out!"
    else if ( quest ) then
       hey = "Sure."
    else 
       hey = "Whatever."
    end if   
  end function hey

end module bob
