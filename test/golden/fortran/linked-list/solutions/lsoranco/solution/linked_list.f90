module linked_list
  implicit none

  type :: node
    type(node), pointer :: next => null()
    type(node), pointer :: prev => null()
    integer             :: value
  end type node

  type :: list_t
    type(node), pointer :: head => null()
  end type list_t

contains

  function new() result(list)
    type(list_t) :: list
  end function new

  subroutine push(list, val)
    type(list_t), intent(inout) :: list
    integer,      intent(in)    :: val

    type(node), pointer :: new_node
    type(node), pointer :: current_node
    
    allocate(new_node)
    new_node%value = val
    ! Special case for an empty list
    if (.not. associated(list%head)) then
        list%head => new_node
        return
    end if

    current_node => list%head
    do while (associated(current_node%next))
        current_node => current_node%next
    end do
    current_node%next => new_node
    new_node%prev => current_node
  end subroutine push

  function pop(list) result(val)
    type(list_t), intent(inout) :: list
    integer :: val

    type(node), pointer :: current_node

    if (.not. associated(list%head)) then
      val = -1 
      return
    end if

    current_node => list%head
    do while (associated(current_node%next))
      current_node => current_node%next
    end do
    val = current_node%value
    ! In most cases, there is a previous element
    if (associated(current_node%prev)) then
      ! Go one step back...
      current_node => current_node%prev
      ! Deallocate the last node in the list
      deallocate(current_node%next)
      ! Don't leave any dangling references
      current_node%next => null()
    ! Special case of deleting a single-value list
    else
      ! Deallocate the only node in the list
      deallocate(current_node)
      ! Remove dangling references
      list%head => null()
    endif

  end function pop

  subroutine unshift(list, val)
    type(list_t), intent(inout) :: list
    integer, intent(in) :: val

    type(node), pointer :: new_node

    allocate(new_node)
    new_node%value = val
    new_node%next => list%head
    if (associated(list%head)) then
      list%head%prev => new_node
    endif
    list%head => new_node
  end subroutine unshift

  function shift(list) result(val)
    type(list_t), intent(inout) :: list
    integer :: val

    type(node), pointer :: current_node

    if (.not. associated(list%head)) then
        val = -999
        return
    endif

    current_node => list%head
    val = current_node%value
    if (associated(current_node%next)) then
      list%head => list%head%next
      deallocate(current_node)
      list%head%prev => null()
    else
      deallocate(current_node)
      list%head => null()
    end if
  end function shift

  function length(list) result(n)
    type(list_t), intent(in) :: list
    integer :: n
    type(node), pointer :: current_node
    n = 0
    if (.not. associated(list%head)) then
      return
    endif

    current_node => list%head
    n = 1
    do while (associated(current_node%next))
      current_node => current_node%next
      n = n + 1
    end do
  end function length

  subroutine delete(list, val)
    type(list_t), intent(inout) :: list
    integer :: val

    type(node), pointer :: current_node
    integer :: temp

    if (.not. associated(list%head)) then
      return
    endif

    current_node => list%head
    ! Case in which the head of the list has the element to be deleted
    if (current_node%value == val) then
        temp = shift(list)
        return
    endif
    ! The loop will catch cases in middle of list
    do while (associated(current_node%next))
      if (current_node%value == val) then
        current_node%prev%next => current_node%next
        current_node%next%prev => current_node%prev
        ! Only deallocates, the other nodes already have the right references
        deallocate(current_node)
        return
      end if
      current_node => current_node%next
    end do
    ! Finally, maybe the last element must be deleted
    if (current_node%value == val) then
        temp = pop(list)
    end if
  end subroutine delete

  subroutine destroy(list)
    type(list_t), intent(inout) :: list

    integer :: counter, temp, list_length

    list_length = length(list)

    do counter=1,list_length
      ! Possibly slower, but I don't want to risk
      ! writting another function that will do the memory stuff itself
      temp = shift(list)
    end do

  end subroutine destroy

end module
