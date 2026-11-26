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

  logical function is_triangle_real(edges)
    real, dimension(3) :: edges

    is_triangle_real = all(edges > 0) .and. 2 * maxval(edges) < sum(edges)
  end function

  logical function is_triangle_int(edges)
    integer, dimension(3) :: edges

    is_triangle_int = all(edges > 0) .and. 2 * maxval(edges) < sum(edges)
  end function

  logical function equilateral_real(edges)
    real,dimension(3) :: edges

    equilateral_real = is_triangle_real(edges) &
      .and. all(edges == edges(1))
  end function

  logical function equilateral_int(edges)
    integer,dimension(3) :: edges

    equilateral_int = is_triangle_int(edges) &
      .and. all(edges == edges(1))
  end function

  logical function isosceles_real(edges)
    real,dimension(3) :: edges

    isosceles_real = is_triangle_real(edges) &
      .and. (count(edges == maxval(edges)) >= 2 .or. count(edges == minval(edges)) >= 2)
  end function

  logical function isosceles_int(edges)
    integer,dimension(3) :: edges

    isosceles_int = is_triangle_int(edges) &
      .and. (count(edges == maxval(edges)) >= 2 .or. count(edges == minval(edges)) >= 2)
  end function


  logical function scalene_real(edges)
    real,dimension(3) :: edges

    scalene_real = is_triangle_real(edges) &
      .and. edges(1) /= edges(2) &
      .and. edges(1) /= edges(3) &
      .and. edges(2) /= edges(3)
  end function

  logical function scalene_int(edges)
    integer,dimension(3) :: edges

    scalene_int = is_triangle_int(edges) &
      .and. edges(1) /= edges(2) &
      .and. edges(1) /= edges(3) &
      .and. edges(2) /= edges(3)
  end function

end module
