
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

  ! Determine the index of the largest element
  integer function major_real(edges)
    real,dimension(3) :: edges
    major_real = 1
    if (edges(2).gt.edges(1)) major_real = 2
    if (edges(3).ge.edges(major_real)) major_real = 3
  end function

  integer function major_int(edges)
    integer,dimension(3) :: edges
    major_int = 1
    if (edges(2).gt.edges(1)) major_int = 2
    if (edges(3).ge.edges(major_int)) major_int = 3
  end function

  ! Determine if the 3 numbers represent an actual triangle.
  ! If the longest side is at least half the total perimeter
  ! then the two shorter sides can't reach each other and
  ! the edges do not represent a triangle at all
  logical function valid_real(edges)
    real,dimension(3) :: edges
    real :: total
    integer :: mx
    mx = major_real(edges) ! Longest edge
    total = edges(1) + edges(2) + edges(3) ! Total perimeter
    valid_real = edges(mx) .lt. (total / 2.0)
  end function

  logical function valid_int(edges)
    integer,dimension(3) :: edges
    integer :: total
    integer :: mx
    mx = major_int(edges) ! Longest edge
    total = edges(1) + edges(2) + edges(3) ! Total perimeter
    valid_int = edges(mx) .lt. (total / 2.0)
  end function

  logical function equilateral_real(edges)
    real,dimension(3) :: edges
    equilateral_real = .false.
    if (edges(1).ne.edges(2)) return
    if (edges(1).ne.edges(3)) return
    if (edges(1).le.0.0) return
    equilateral_real = valid_real(edges)
  end function

  logical function equilateral_int(edges)
    integer,dimension(3) :: edges
    equilateral_int = .false.
    if (edges(1).ne.edges(2)) return
    if (edges(1).ne.edges(3)) return
    if (edges(1).le.0) return
    equilateral_int = .true.
  end function

  logical function isosceles_real(edges)
    real,dimension(3) :: edges
    integer :: i,j
    isosceles_real = .false.
    do i = 1,3
      j = i + 1
      if (j.gt.3) j = 1
      if (edges(i).eq.edges(j)) isosceles_real = valid_real(edges)
    end do
  end function

  logical function isosceles_int(edges)
    integer,dimension(3) :: edges
    integer :: i,j
    isosceles_int = .false.
    do i = 1,3
      j = i + 1
      if (j.gt.3) j = 1
      if (edges(i).eq.edges(j)) isosceles_int = valid_int(edges)
    end do
 end function

  logical function scalene_real(edges)
    real,dimension(3) :: edges
    scalene_real = edges(1).ne.edges(2).and. &
      edges(1).ne.edges(3).and. &
      edges(2).ne.edges(3).and. &
      valid_real(edges)
  end function

  logical function scalene_int(edges)
    integer,dimension(3) :: edges
    scalene_int = edges(1).ne.edges(2).and. &
      edges(1).ne.edges(3).and. &
      edges(2).ne.edges(3).and. &
      valid_int(edges)
  end function

end module
