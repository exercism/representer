module sum_of_multiples
  implicit none
  private
  public :: sum_multiples
contains

  function sum_multiples(factors, limit) result(res)
    integer, intent(in) :: factors(:), limit
    integer :: res
    integer :: n_multiples ! Only used in sum_multiples_l

    if (limit < 1000) then
      res = sum_multiples_s(factors, limit - 1, n_multiples)
    else
      res = sum_multiples_l(factors, limit)
    end if
  end function sum_multiples

  function sum_multiples_l(factors, limit) result(res)
    integer, intent(in) :: factors(:), limit
    integer :: res
    integer :: lcm, n_multiples, n_divisions
    ! This version is optimized for very large limits and small factors.
    !
    ! The idea is to only sum the multiples up to the least common multiple
    ! of all the factors, and then do some simple arithmetic to account for
    ! remaining multiples.

    lcm = least_common_multiple(factors, limit)
    if (lcm == 0) then
      res = sum_multiples_s(factors, limit - 1, n_multiples)
    else
      ! The numbers from 1 to the limit can be divided into lcm-sized
      ! blocks, each of which contains n_multiples multiples of the factors.
      n_divisions = (limit - 1)/lcm
      res = sum_multiples_s(factors, lcm, n_multiples)*n_divisions
      ! The the multiples in each block correspond to the multiples of
      ! in the first block, offset by multiples of lcm, and the per block
      ! sum grows by lcm*n_multiples for each block. This can be accounted
      ! for using the arithmetic sum formula.
      res = res + n_multiples*lcm*(n_divisions*(n_divisions - 1)/2)
      ! For the remaining numbers, the multiples are summed again manually,
      ! and the "offset" is accounted for in a similar fashion as above.
      res = res + sum_multiples_s(factors, mod(limit - 1, lcm), n_multiples)
      res = res + n_multiples*lcm*n_divisions
    end if
  end function sum_multiples_l

  function sum_multiples_s(factors, limit, n_multiples) result(res)
    integer, intent(in) :: factors(:), limit
    integer, intent(out) :: n_multiples
    integer :: res
    integer :: i, j, f, i_max, multiple, ia, ii
    integer, parameter :: int_size = bit_size(limit)
    integer, dimension(limit/int_size + 1) :: bitarray
    ! This version should be reaonably fast for the most part,
    ! especially for large factors and moderate limits.
    !
    ! It uses a bitarray to keep track of which multiples have already
    ! been added to the sum, which increases the memory usage but should
    ! be comparitively fast.
    ! At least using a bitarray over a logical array should limit memory
    ! usage somewhat in case the limit is very large.
    
    bitarray = 0
    res = 0
    i = 1
    n_multiples = 0
    do j = 1, size(factors)
      f = factors(j)

      if (f == 0) cycle
      if ( any(mod(f,factors(1:j-1)) == 0) ) cycle

      i_max = limit/f
      do i = 1,i_max
        multiple = f*i
        ia = multiple/int_size
        ii = multiple - ia - 1

        if (btest(bitarray(ia + 1),ii)) cycle

        res = res + multiple
        n_multiples = n_multiples + 1
        bitarray(ia - 1) = ibset(bitarray(ia + 1),ii)
      end do
    end do
  end function sum_multiples_s

  pure function least_common_multiple(factors, limit) result(lcm)
    integer, intent(in) :: factors(:), limit
    integer :: lcm
    integer :: fmax, val

    lcm = 0

    fmax = maxval(factors)
    if (fmax == 0) return

    val = fmax
    do while (val < limit)
      if (all(factors == 0 .OR. mod(val, max(factors,1)) == 0)) then
        lcm = val
        return
      end if
      val = val + fmax
    end do
  end function least_common_multiple

end module sum_of_multiples
