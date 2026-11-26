
module yacht
   implicit none

   ! | Ones | 1 × number of ones | Any combination	| 1 1 1 4 5 scores 3 |
   ! | Twos | 2 × number of twos | Any combination | 2 2 3 4 5 scores 4 |
   ! | Threes | 3 × number of threes | Any combination | 3 3 3 3 3 scores 15 |
   ! | Fours | 4 × number of fours | Any combination | 1 2 3 3 5 scores 0 |
   ! | Fives | 5 × number of fives| Any combination | 5 1 5 2 5 scores 15 |
   ! | Sixes | 6 × number of sixes | Any combination | 2 3 4 5 6 scores 6 |
   ! | Full House | Total of the dice | Three of one number and two of another | 3 3 3 5 5 scores 19 |
   ! | Four of a Kind | Total of the four dice | At least four dice showing the same face | 4 4 4 4 6 scores 16 |
   ! | Little Straight |  30 points | 1-2-3-4-5 | 1 2 3 4 5 scores 30 |
   ! | Big Straight | 30 points | 2-3-4-5-6 | 2 3 4 5 6 scores 30 |
   ! | Choice | Sum of the dice | Any combination | 2 3 3 4 6 scores 18 |
   ! | Yacht | 50 points | All five dice showing the same face | 4 4 4 4 4 scores 50 |


contains

   function count_dice(dice) result(out)
      integer, dimension(5), intent(in) :: dice
      integer, dimension(6) :: out
      integer :: i
      out = 0
      do i = 1, size(dice)
         out(dice(i)) = out(dice(i)) + 1
      end do
   end function count_dice

   integer function score(dice, yacht_type)
      integer, dimension(5), intent(in) :: dice
      character(len=*), intent(in) :: yacht_type
      integer, dimension(6) :: aux
      integer :: i
      aux = count_dice(dice)
      score = 0
      select case (yacht_type)
       case ("ones")
         score = aux(1) * 1
       case ("twos")
         score = aux(2) * 2
       case ("threes")
         score = aux(3) * 3
       case ("fours")
         score = aux(4) / 4
       case ("fives")
         score = aux(5) * 5
       case ("sixes")
         score = aux(6) * 6
       case ("four of a kind")
         do i = 1, size(aux)
            if ( aux(i) >= 4 ) then
               score = i * 4
            end if
         end do
       case ("full house")
         if ( any(aux(:) == 2) .and. any(aux(:) == 3) ) then
            score = sum(dice)
         end if
       case ("yacht")
         if ( any(aux == 5) ) then
            score = 50
         end if
       case ("choice")
         score = sum(dice)
       case ("little straight")
         if ( all(aux(:5) == 1) ) then
            score = 30
         end if
       case ("big straight")
         if ( all(aux(2:) == 1) ) then
            score = 30
         end if
       case default
         score = 0
      end select
   end function


end module
