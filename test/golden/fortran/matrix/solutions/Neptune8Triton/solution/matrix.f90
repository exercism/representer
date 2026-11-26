
module matrix
  implicit none

contains

  function row(m_as_char, m_dim, which_row) result(return_row)
    !> functions row takes an arg, m_as_char as character representation of a
    !> matrix m(nr,nc).
    !> Each element of m_as_char is a "row" of values, i.e.
    !> m_as_char = ["2,1,3","8,7,6"] would be a 2x3 matrix, with
    !> m_as_char(1) = "1,2,3" and m_as_char(2) = "4,5,6"
    !> An internal file read is used to convert each string, m_as_char into a row
    !> of A(nr,nc), an integer matrix. Each dimension of m is given in
    !> m_dim. The number of rows nr = m_dim(1), and number of cols nc = m_dim(2).
    !> The function return of values of A(which_row,:)

    implicit none
    character(len=*), intent(in) :: m_as_char(:)
    integer, intent(in) :: m_dim(2)
    integer, intent(in) :: which_row
    integer :: r, c
    integer,dimension(m_dim(2)) :: return_row
    integer :: A(m_dim(1),m_dim(2))

    !> use internal read to get m_as_char to integer Matrix A
    do r = 1, m_dim(1)
      read(m_as_char(r), *) (A(r,c), c = 1, m_dim(2))
    end do
    !print *, ((A(r,c), c=1,m_dim(2)),r=1,m_dim(1))

    return_row(:) = A(which_row,:)

  end function

  function column(m_as_char, m_dim, which_col) result(return_col)
    implicit none
    character(len=*), intent(in) :: m_as_char(:)
    integer, intent(in) :: m_dim(2)
    integer :: r,c
    integer :: which_col
    integer :: A(m_dim(1),m_dim(2))
    integer,dimension(m_dim(1)) :: return_col

    !> use internal read to get m_as_char to integer Matrix A
    do r = 1, m_dim(1)
      read(m_as_char(r), *) (A(r,c), c = 1, m_dim(2))
    end do

    return_col(:) = A(:,which_col)

  end function

end module
