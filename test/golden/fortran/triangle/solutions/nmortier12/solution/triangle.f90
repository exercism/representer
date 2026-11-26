module triangle
    implicit none

    interface equilateral
        module procedure equilateral_real
        module procedure equilateral_int
    end interface

    interface scalene
        module procedure scalene_real
        module procedure scalene_int
    end interface

    interface isosceles
        module procedure isosceles_real
        module procedure isosceles_int
    end interface

contains

    logical function triangle_valid(e)
        integer, dimension(3) :: e

        if((e(1) + e(2)) < e(3) .or. (e(1) + e(3)) < e(2) .or. (e(2) + e(3)) < e(1)) then
            triangle_valid = .false.
        else
            triangle_valid = .true.
        end if

    end function


    logical function equilateral_real(edges)
        real, dimension(3) :: edges

        if(edges(1) == edges(2) .and. edges(1) == edges(3) .and. edges(1) /= 0) then
            equilateral_real = .true.
        else
            equilateral_real = .false.
        end if

    end function

    logical function equilateral_int(edges)
        integer, dimension(3) :: edges

        if(edges(1) == edges(2) .and. edges(1) == edges(3) .and. edges(1) /= 0) then
            equilateral_int = .true.
        else
            equilateral_int = .false.
        end if
    end function

    logical function isosceles_real(edges)
        real, dimension(3) :: edges

        if(equilateral_real(edges) .or. edges(1) == edges(2) .or. edges(1) == edges(3) .or. edges(2) == edges(3)) then
            isosceles_real = .true.
        else
            isosceles_real = .false.
        end if

    end function

    logical function isosceles_int(edges)
        integer, dimension(3) :: edges

        if( triangle_valid(edges) .eqv. .false. ) then
            isosceles_int = .false.
            return
        end if

        if(equilateral_int(edges) .or. edges(1) == edges(2) .or. edges(1) == edges(3) .or. edges(2) == edges(3)) then
            isosceles_int = .true.
        else
            isosceles_int = .false.
        end if

    end function


    logical function scalene_real(edges)
        real, dimension(3) :: edges

        scalene_real = .not. isosceles_real(edges) .and. .not. equilateral_real(edges)

    end function

    logical function scalene_int(edges)
        integer, dimension(3) :: edges

        scalene_int = triangle_valid(edges) .and. .not. isosceles_int(edges) .and. .not. equilateral_int(edges)

    end function

end module
