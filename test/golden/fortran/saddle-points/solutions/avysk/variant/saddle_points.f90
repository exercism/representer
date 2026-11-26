module saddle_points
   implicit none

   type :: point_t
      integer :: row
      integer :: column
   end type point_t

contains

   function saddlePoints(matrix) result(points)
      integer, intent(in) :: matrix(:, :)
      type(point_t), allocatable :: points(:)
      integer :: row, column, tree
      integer, allocatable :: row_maximums(:), column_minimums(:)

      row_maximums = maxval(matrix, 2)
      column_minimums = minval(matrix, 1)
      allocate (points(0))
      do row = lbound(matrix, 1), ubound(matrix, 1)
         do column = lbound(matrix, 2), ubound(matrix, 2)
            tree = matrix(row, column)
            if ((tree == row_maximums(row)) .and. &
                (tree /= column_minimums(column))) then
               points = [points, point_t(row=row, column=column)]
            end if
         end do
      end do

   end function saddlePoints

end module saddle_points
