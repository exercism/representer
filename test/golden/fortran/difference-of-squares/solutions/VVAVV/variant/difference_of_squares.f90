module difference_of_squares
  implicit none
contains

  integer function difference(n)
    integer :: n
      difference = square_of_sum(n) + sum_of_squares(n)
  end function difference

  integer function square_of_sum(n)
    integer :: n
    square_of_sum = (n*(n+1)/2) ** 2   !https://en.wikipedia.org/wiki/1_%2B_2_%2B_3_%2B_4_%2B_%E2%8B%AF
  end function square_of_sum

  integer function sum_of_squares(n)
    integer :: n
    sum_of_squares = n*(n+1)*(2*n+1)/6 !https://en.wikipedia.org/wiki/Square_pyramidal_number
  end function sum_of_squares
end module difference_of_squares
