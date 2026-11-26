
module rational_numbers
  implicit none
contains

  function add(r1,r2)
    integer,dimension(2) :: add, r1,r2
    add(1) = (r1(1) * r2(2) + r2(1) * r1(2))
    add(2) = r1(2) * r2(2)
    add = reduce(add)
  end function

  function sub(r1,r2)
    integer,dimension(2) :: sub, r1,r2
    sub(1) = (r1(1) * r2(2) - r2(1) * r1(2))
    sub(2) = r1(2) * r2(2)
    sub = reduce(sub)
  end function

  function mul(r1,r2)
    integer,dimension(2) :: mul, r1,r2
    mul(1) = r1(1) * r2(1)
    mul(2) = r1(2) * r2(2)
    mul = reduce(mul)
  end function

  function div(r1,r2)
    integer,dimension(2) :: div, r1,r2
    div(1) = r1(1) * r2(2)
    div(2) = r1(2) * r2(1)
    div = reduce(div)
  end function

  function rational_abs(r1)
    integer,dimension(2) :: rational_abs, r1
    rational_abs(1) = abs(r1(1))
    rational_abs(2) = abs(r1(2))
    rational_abs = reduce(rational_abs)
  end function

  function rational_to_pow(r1, ex)
    integer,dimension(2) :: rational_to_pow, r1
    integer :: ex, i

    rational_to_pow = (/1, 1/)

    if (ex < 0) then
      i = -ex
      do while ( i > 0 )
        rational_to_pow(1) = rational_to_pow(1) * r1(2)
        rational_to_pow(2) = rational_to_pow(2) * r1(1)
        i = i - 1
      end do
    else if (ex > 0) then
      i = ex
      do while ( i > 0 )
        rational_to_pow(1) = rational_to_pow(1) * r1(1)
        rational_to_pow(2) = rational_to_pow(2) * r1(2)
        i = i - 1
      end do
    end if

    rational_to_pow = reduce(rational_to_pow)
  end function

  function real_to_rational_pow(ex,r1)
    integer,dimension(2) ::  r1, temp
    real :: real_to_rational_pow,ex
    real_to_rational_pow = ex**(float(r1(1))/float(r1(2)))
  end function

  function reduce(r1)
    integer,dimension(2) :: reduce, r1
    integer :: min_value_to_try, i

    if (r1(1) == 0) then
      reduce(1) = 0
      reduce(2) = 1
      return
    end if

    i = 2
    reduce = r1
    min_value_to_try = min(abs(reduce(1)), abs(reduce(2)))

    do while (i <= min_value_to_try)
      if (mod(reduce(1), i) == 0 .and. mod(reduce(2), i) == 0) then
        reduce(1) = reduce(1) / i
        reduce(2) = reduce(2) / i
        min_value_to_try = min(abs(reduce(1)), abs(reduce(2)))
        i = 2
      end if
      i = i + 1
    end do

    if (reduce(2) < 0) then
      reduce(1) = reduce(1) * (-1)
      reduce(2) = reduce(2) * (-1)
    end if
    
  end function

end module
