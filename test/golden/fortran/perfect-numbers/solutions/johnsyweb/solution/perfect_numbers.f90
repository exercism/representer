
module perfect_numbers
  implicit none
contains
  character(len=9) function classify(num)
    integer, intent(in) :: num
    integer :: aliquot_sum

    aliquot_sum = sum(factors(num))
    
    if (num < 1) then    
      classify = "ERROR"
    else if (num < 3 .or. aliquot_sum < num) then
      classify = "deficient"
    else if (aliquot_sum == num) then
      classify = "perfect"
    else
      classify = "abundant"
    end if
  end function

  function factors(n)
    integer, intent(in) :: n
    integer, dimension(2 * ceiling(sqrt(real(n)))) :: factors
    integer :: f, i

    if (n < 1) then
      return
    end if
    
    factors = 0
    i = 1

    do f = 1, floor(sqrt(real(n)))
      if (mod(n, f) == 0) then
        factors(i) = f
        i = i + 1
        if (f ** 2 /= n .and. f /= 1) then
          factors(i) = n / f
          i = i + 1
        end if
      end if
    end do
  end function
end module
