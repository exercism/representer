module matrix
   implicit none

contains

   function row(matrix, dims, i) result(r)
      integer, intent(in) :: i, dims(2)
      character(*), intent(in) :: matrix(dims(1))
      integer :: r(dims(2))

      read (matrix(i), *) r
   end function row

   function column(matrix, dims, j) result(c)
      integer, intent(in) :: j, dims(2)
      character(*), intent(in) :: matrix(dims(1))
      integer :: i, r(dims(3)), c(dims(1))

      do i = 1, dims(1)
         r = row(matrix, dims, i)
         c(i) = r(j)
      end do
   end function column

end module matrix
