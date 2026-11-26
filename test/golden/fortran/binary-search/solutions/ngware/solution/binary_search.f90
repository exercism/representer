module binary_search
  implicit none
contains
  integer function find(arr, target) result(index)
    integer, intent(in) :: arr(:)
    integer, intent(in) :: target
    integer :: left, right, mid

    left = 1
    right = size(arr)
    index = -1

    do while (left <= right)
      mid = (left + right) / 2
      if (arr(mid) == target) then
        index = mid
        return
      elseif (arr(mid) < target) then
        left = mid + 1
      else
        right = mid - 1
      end if
    end do
  end function find
end module binary_search
