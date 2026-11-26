module nth_prime
  implicit none
contains

  ! get nth prime
    integer function prime(n)
    integer :: n, i, j, p
    real, allocatable  :: x(:)
    logical :: isPrime

    p = 0
    allocate(x(n))

! take care of 0 not prime number
    if (n .eq. 0) then
      prime = -1
    else

    do i = 2, (2*n)**(2) !some number greater than n will ever be
      isPrime = .true.

! Modulo check - if no remainder, number cannot be prime
        do  j = 2, int(sqrt(real(i)))
            if (mod(i, j) == 0) then 
               isPrime = .false.
               exit
            endif
        enddo

! if fails modulo check above, then prime
        if (isPrime) then
          p = p + 1 !counter
          x(p) = i !add to array
        endif
        if ( p .ge. n) then  ! stop loop if array has reached length n
          exit 
        endif
    enddo

! recall last number from array
    prime = x(n)
    
    deallocate(x)
    endif
  end function

end module
