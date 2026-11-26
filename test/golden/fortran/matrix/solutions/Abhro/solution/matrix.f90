
module matrix
  implicit none

  private
  public :: row, column
contains

  function row(m, m_dim, i) result(r)
    ! given matrix encoded in m, and the row indicated by i, set r to i-th row
    ! shape of the matrix is given by m_dim
    character(len=*), intent(in) :: m(:)
    integer, intent(in) :: m_dim(2)
    integer, intent(in) :: i
    integer, dimension(m_dim(2)) :: r
    integer :: A(m_dim(1),m_dim(2))
    A = parse_matrix(m, m_dim)
    r(:) = A(i,:)
  end function row

  function column(m, m_dim, j) result(c)
    ! given matrix encoded in m, and the col indicated by j, set r to j-th col
    ! shape of the matrix is given by m_dim
    character(len=*), intent(in) :: m(:)
    integer, intent(in) :: m_dim(2)
    integer, intent(in) :: j
    integer, dimension(m_dim(1)) :: c
    integer :: A(m_dim(1),m_dim(2))
    A = parse_matrix(m, m_dim)
    c(:) = A(:,j)
  end function column

  function parse_matrix(m, m_dim) result(A)
    ! return a matrix (rank-2 array) of integers from an array of strings,
    ! where each string is a row
    character(len=*), intent(in) :: m(:)
    integer, intent(in) :: m_dim(2)
    integer :: A(m_dim(1),m_dim(2))
    integer :: k
    do k = 1, size(m, 1)
      read(m(k), *) A(k,:)
    end do
  end function parse_matrix

end module
