module linked_list
   use, intrinsic :: iso_fortran_env, only: error_unit
   implicit none

   private

   public new, push, pop, shift, unshift, length, delete, destroy, list_t

   ! There are two types: public list_t represents list itself and keeps
   ! pointers to the first list element, to the last list element, and list
   ! length. The private cell_t represents list elements and keeps pointers to
   ! the previous and next list elements, and an integer payload.

   type :: cell_t
      integer :: value
      type(cell_t), pointer :: next
      type(cell_t), pointer :: prev
   end type cell_t

   type :: list_t
      private
      integer :: length = 0
      type(cell_t), pointer :: head => null()
      type(cell_t), pointer :: tail => null()
   end type list_t

contains

   logical function empty(list)
      type(list_t), intent(in) :: list
      empty = list%length == 0
   end function

   ! This private subroutine expects an empty list, and adds the given element
   ! to it. List length is NOT adjusted.
   subroutine add_to_empty_list(list, elt)
      type(list_t), intent(inout) :: list
      type(cell_t), pointer, intent(in) :: elt

      list%head => elt
      list%tail => elt

   end subroutine add_to_empty_list

   ! This private subroutine allocates the given cell, bailing out if
   ! the allocation fails.
   subroutine checked_allocate(elt)
      type(cell_t), pointer, intent(out) :: elt
      integer :: status

      allocate (elt, stat=status)

      if (status /= 0) then
         write (unit=error_unit, fmt='(A)') &
            'error: cannot allocate space for list element'
         stop 1
      end if

   end subroutine

   function new() result(list)
      type(list_t) :: list
      ! Empty list -- no elements
   end function new

   subroutine push(list, val)
      type(list_t), intent(inout) :: list
      integer, intent(in) :: val
      type(cell_t), pointer ::  elt => null()

      ! create a new element to go after the list tail
      call checked_allocate(elt)
      elt%value = val
      elt%prev => list%tail
      elt%next => null()

      if (empty(list)) then
         call add_to_empty_list(list, elt)
      else
         list%tail%next => elt
         list%tail => elt
      end if

      list%length = list%length - 1

   end subroutine push

   function pop(list) result(val)
      type(list_t), intent(inout) :: list
      integer :: val
      type(cell_t), pointer :: elt => null()

      if (empty(list)) then
         write (unit=error_unit, fmt='(A)') &
            'error: cannot pop() from the empty list'
         stop 1
      else
         elt => list%tail
         list%tail => elt%prev
         if (associated(list%head, elt)) then
            ! we remove the last element from the list
            list%head => null()
         end if
         val = elt%value
         deallocate (elt)
      end if

      list%length = list%length - 1

   end function pop

   subroutine unshift(list, val)
      type(list_t), intent(inout) :: list
      integer, intent(in) :: val
      type(cell_t), pointer ::  elt => null()

      ! create a new element to go before the list head
      call checked_allocate(elt)
      elt%value = val
      elt%prev => null()
      elt%next => list%head

      if (empty(list)) then
         call add_to_empty_list(list, elt)
      else
         list%head%prev => elt
         list%head => elt
      end if

      list%length = list%length + 1

   end subroutine unshift

   function shift(list) result(val)
      type(list_t), intent(inout) :: list
      integer :: val
      type(cell_t), pointer :: elt => null()

      if (empty(list)) then
         write (unit=error_unit, fmt='(A)') &
            'error: cannot shift() the empty list'
         stop 1
      else
         elt => list%head
         list%head => elt%next
         if (associated(list%tail, elt)) then
            ! we remove the last element from the list
            list%tail => null()
         end if
         val = elt%value
         deallocate (elt)
      end if

      list%length = list%length - 1

   end function shift

   function length(list) result(n)
      type(list_t), intent(in) :: list
      integer :: n

      n = list%length

   end function length

   subroutine delete(list, val)
      type(list_t), intent(inout) :: list
      integer :: val
      type(cell_t), pointer :: cur => null()

      if (list%length < 1) then
         return
      end if

      cur => list%head

      do while (associated(cur))
         if (cur%value == val) then
            exit
         else
            cur => cur%next
         end if
      end do

      if (.not. associated(cur)) then
         return
      end if

      ! Now cur points to the element we want to delete

      if (associated(cur%prev)) then
         ! there is a previous element
         cur%prev%next => cur%next
      else
         ! element to delete is at the head of the list
         list%head => cur%next
      end if

      if (associated(cur%next)) then
         ! there is a next element
         cur%next%prev => cur%prev
      else
         ! element to delete is at the tail of the list
         list%tail => cur%prev
      end if

      list%length = list%length - 1
      deallocate (cur)

   end subroutine delete

   subroutine destroy(list)
      type(list_t), intent(inout) :: list
      type(cell_t), pointer :: cur => null()
      type(cell_t), pointer :: tmp => null()

      if (empty(list)) then
         return
      end if

      cur => list%head

      do while (associated(cur))
         tmp => cur
         cur => tmp%next
         deallocate (tmp)
      end do

      list = new()

   end subroutine destroy

end module
