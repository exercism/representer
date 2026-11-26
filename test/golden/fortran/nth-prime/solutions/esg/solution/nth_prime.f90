module nth_prime
  implicit none
contains

  ! get nth prime
  integer function prime(n)
    integer, intent(in) :: n
    integer :: nfound, candidate, i, j
    logical :: isprime

    select case (n)
    case (:0)
       prime = -1
    case (1)
       prime = 2
    case (2)
       prime = 3
    case default
       nfound = 2
       i = 0
       do while (nfound < n)
          i = i + 1
          ! we only need to check numbers congruent to 1 or 5 mod 6.
          candidate = (i / 2) * 6 + merge(1, 5, mod(i, 2) == 0)
          isprime = .true.
          do j = 3, floor(sqrt(real(candidate))), 2
             if (mod(candidate, j) == 0) then
                isprime = .false.
                exit
             end if
          end do
          if (isprime) then
             nfound = nfound + 1
          end if
       end do
       prime = candidate
    end select
  end function prime

end module nth_prime
