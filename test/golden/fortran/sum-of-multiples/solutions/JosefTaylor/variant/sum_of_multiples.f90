module sum_of_multiples
  implicit none

contains

  function sum_multiples(factors, limit) result(res)
    integer, intent(in) :: factors(:), limit
    integer :: res, i, number, n_seen
    integer, allocatable :: seen(:)

    allocate(seen(sum(limit/factors, mask=(factors > 0))))

    res = 0      
    seen(:) = 0
    n_seen = 0

    ! Limit too small, cannot hit.
    if (limit <= 0) return

    do i=1,size(factors)
      number = factors(i)
      if (number <= 0) cycle
      do while (number <= limit)
        if ( .not. any(seen == number) ) then
          n_seen = n_seen + 1
          seen(n_seen) = number
          res = res + number
        end if
        number = number + factors(i)
      end do
    end do

    deallocate(seen)

  end function sum_multiples

end module sum_of_multiples
