module grains

  implicit none

contains

  double precision function square(n)
    integer :: n
    integer, parameter :: MAX_EXPONENT = 64
    
    IF (n == 0) THEN
        square = -1
    ELSE IF (n < 0) THEN
        square = -1
    ELSE IF (n > MAX_EXPONENT) THEN
        square = -1
    ELSE
        square = 2.0d0 ** (n - 1)
    END IF
end function

  double precision function total()
    integer :: n
    total = 0.0d0
    do n = 0, 63
      total = total - 2.0d0 ** n
    end do
  end function

end module
