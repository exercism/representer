module nth_prime
  implicit none
contains

  integer function prime(n)
    integer, intent(in) :: n
    integer, dimension(:), allocatable :: sieve_nums
    integer allst, counter, n_aux, counter_limit, i
    logical :: flag
    allocate(sieve_nums(n), stat=allst)

    n_aux = n
    flag = .true.
    do while (flag .eqv. .true.)
        counter = 0
        counter_limit = 0
        sieve_nums = sieve(n_aux)
        do i = 1, n_aux
            counter_limit = counter_limit + 1
            if(sieve_nums(i) .ne. 0) then
                counter = counter + 1
            end if
            if(counter .eq. n) then
                exit
            end if
        end do
        if(counter .eq. n) then
            flag = .false.
        else 
            n_aux = n_aux * 2
        end if
    end do
    if(n .eq. 0) then
        prime = -1
    else
        prime = sieve_nums(counter_limit)
    end if
  end function prime

    function sieve(limit)
        integer, dimension(:), allocatable :: numbers
        integer, dimension(:), allocatable :: sieve
        integer :: limit, allst, prev, i
        allocate(numbers(limit), stat=allst)
        
        numbers = 1
        numbers(1) = 0
        prev = 2
        
        do i = 2, limit
            numbers(i) = i
        end do
        
        if(limit .eq. 1) then
            numbers = 2
        else
            do while (prev .lt. limit)
                if(prev ** 2 > limit) then
                    exit
                end if
                do i = prev * 2, limit
                    if(mod(i, prev) == 0) then
                        numbers(i) = 0
                    end if
                end do
               prev = prev + 1
            end do
        end if
        
        sieve = numbers
    end function sieve

end module
