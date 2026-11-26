module nth_prime
  implicit none
contains

  ! Function to find the nth prime number
  integer function prime(n)
    integer, intent(in) :: n
    integer :: candidate, count, num_primes, i
    logical :: is_prime

    if (n <= 0) then
        prime = -1  ! Return -1 if n is not positive
        return
    endif

    candidate = 2  ! Start with the first prime number
    count = 0      ! Count the number of primes found
    num_primes = 0 ! Track the nth prime number
    
    do while (count < n)
        is_prime = .true.
        do i = 2, candidate - 1
            if (mod(candidate, i) == 0) then
                is_prime = .false.
                exit
            endif
        end do
        
        if (is_prime) then
            count = count + 1
            num_primes = candidate
        endif
        
        candidate = candidate + 1
    end do
    
    prime = num_primes
  end function

end module
