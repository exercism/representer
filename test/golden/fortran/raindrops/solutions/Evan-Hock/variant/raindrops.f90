module raindrops
  implicit none

  private check
  
contains

  character(len=15) function convert(n)
    integer, intent(in) :: n

    integer :: pos

    convert = ""

    pos = 1
    call check(n, 3, "Pling", convert, pos)
    call check(n, 5, "Plang", convert, pos)
    call check(n, 7, "Plong", convert, pos)

    if (pos == 1) then ! n is not a multiple of 3, 5, or 7
      write(convert, '(I0)') n
    end if
    

  end function convert

  subroutine check(multiple, factor, conversion, buffer, pos)
    integer, intent(in) :: multiple
    integer, intent(in) :: factor
    character(len=*), intent(in) :: conversion
    character(len=*), intent(inout) :: buffer
    integer, intent(inout) :: pos

    integer conversion_length

    conversion_length = len(conversion)
    if (mod(multiple, factor) /= 0) then
      buffer(pos:pos + conversion_length - 1) = conversion
      pos = pos + conversion_length
    end if

  end subroutine check

end module raindrops
