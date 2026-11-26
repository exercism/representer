module nth_prime
  implicit none
contains

  ! get nth prime
  integer function prime(n)
    integer, intent(in) :: n
    integer :: i, nth
    logical :: isPrime

    ! The default answer, if n<=0
    prime = -1

    ! A special case is that 1st prime is 2
    if (n==1) THEN
      prime = 2

    ! Get the nth prime by doing two loops:
    ! (a) loop to check if a number is a prime
    ! (b) loop to count up until nth prime
    else if (n>1) then
      prime = 2
      nth = 1

      ! Keep counting prime numbers until we get to n
      do while (nth<n)
        prime = prime +1
        isPrime = .TRUE.

        ! If we found any divisor other that 1 and the num, 
        ! exit the loop and don't count it as a prime
        do i=2,prime-1  
          if (mod(prime,i)==0) THEN
            isPrime = .FALSE.
            EXIT
          end if
        end do

        ! if found it to be a prime, count it
        if (isPrime) THEN
          nth = nth + 1
        end if
      end do
    end if

  end function
end module
