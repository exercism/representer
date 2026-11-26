
module matrix
  implicit none

contains

  function row(matrix, dims, i) result(r)
    integer, dimension(2), intent(in) :: dims                    !! Matrix dimensions (nrows, ncols)
    character(len=*), dimension(dims(1)), intent(in) :: matrix   !! Matrix as a 1-d array of strings  
    integer, intent(in) :: i                                     !! Row index
    integer, dimension(dims(2)) :: r                             !! A single row 

    read(matrix(i),*) r
    
  end function

  function column(matrix, dims, j) result(c)
    integer, dimension(2), intent(in) :: dims                     !! Matrix dimensions (nrows, ncols)
    character(len=*), dimension(dims(1)), intent(in) :: matrix    !! Matrix as a 1-d array of strings
    integer, intent(in) :: j                                      !! Column index   
    integer, dimension(dims(1)) :: c
    integer, dimension(dims(1)*dims(2)) :: matrix_vector
    integer, dimension(dims(1),dims(2)) :: int_matrix

    read(matrix,*) matrix_vector
    int_matrix = transpose(reshape(matrix_vector, (/ dims(2), dims(1) /)))
    c = int_matrix(:,j)
    
  end function

end module
