module rational_numbers
    implicit none
contains

    function add(r1, r2)
        integer :: add(2), r1(2), r2(2)

        add = reduce([r1(1) * r2(2) + r2(1) * r1(2), &
                r1(2) * r2(2)])
    end function

    function sub(r1, r2)
        integer :: sub(2), r1(2), r2(2)

        sub = reduce([r1(1) * r2(2) - r2(1) * r1(2), &
                r1(2) * r2(2)])
    end function

    function mul(r1, r2)
        integer :: mul(2), r1(2), r2(2)

        mul = reduce([r1(1) * r2(1), &
                r1(2) * r2(2)])
    end function

    function div(r1, r2)
        integer :: div(2), r1(2), r2(2)

        div = reduce([r1(1) * r2(2), &
                r2(1) * r1(2)])
    end function

    function rational_abs(r)
        integer :: rational_abs(2), r(2)

        rational_abs = reduce([abs(r(1)), &
                abs(r(2))])
    end function

    function rational_to_pow(r, ex)
        integer :: rational_to_pow(2), r(2), ex

        if (ex >= 0) then
            rational_to_pow = reduce([r(1)**ex, &
                    r(2)**ex])
        else
            rational_to_pow = reduce([r(2)**(-ex), &
                    r(1)**(-ex)])
        end if
    end function

    function real_to_rational_pow(x, r)
        integer :: r(2)
        real :: real_to_rational_pow, x

        real_to_rational_pow = x**(real(r(1)) / real(r(2)))
    end function

    function gcd(a, b)
        integer :: gcd, a, b, l, m, n

        m = a
        n = b

        do
            l = mod(m, n)
            if (l == 0) exit
            m = n
            n = l
        end do

        gcd = n
    end function

    function reduce(r)
        integer :: reduce(2), r(2), g, a, b

        g = gcd(r(1), r(2))
        a = r(1) / g
        b = r(2) / g

        if (a > 0 .and. b < 0) then
            reduce = [- a, - b]
        else
            reduce = [a, b]
        end if
    end function

end module
