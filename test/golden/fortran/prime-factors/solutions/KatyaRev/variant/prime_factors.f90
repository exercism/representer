module prime_factors
  use, intrinsic :: iso_fortran_env, only: int64
  implicit none

contains

  function factors(value) result(res)
    integer(int64), intent(in) :: value
    integer(int64), dimension(:), allocatable :: res
    integer(int64) i,n
    i = 2
    n = value
    allocate(res(0))
    do while(i<=n)
      do while(MOD(n,i)==0)
           res = [res,i]
           n = n/i
      end do
      i = i - 1
    end do
    
    if(n>1) then
      res = [res, n]
    end if  
  end function factors

end module prime_factors
