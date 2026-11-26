
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
 
  integer :: first, second, count_first, count_second  
  integer, dimension(5) :: sorted
contains

  integer function score(dice, yacht_type)
    integer, dimension(5), intent(in) :: dice
    character(len=*), intent(in) :: yacht_type
    integer :: scores
    scores = 0
    select case(yacht_type)
        case ("ones")
            scores = get_scores(dice, 1)
        case ("twos")
            scores = get_scores(dice, 2)
        case ("threes")
            scores = get_scores(dice, 3)
        case ("fours")
            scores = get_scores(dice, 4)
        case ("fives")
            scores = get_scores(dice, 5)
        case ("sixes")
            scores = get_scores(dice, 6)
       case ("full house")
            sorted = sort(dice)
            count_first = nint((real(sorted(1)) + real(sorted(2)) + real(sorted(3))) / 3)
            count_second = nint((real(sorted(4)) + real(sorted(5))) / 2)
            if((count_first .eq. sorted(1)) .and. (count_second .eq. sorted(4)) .and. (sorted(1) .ne. sorted(5))) then
                scores = sorted(1) + sorted(2) + sorted(3) + sorted(4) + sorted(5)
            end if 
            count_first = nint((real(sorted(1)) + real(sorted(2))) / 2)
            count_second = nint((real(sorted(3)) + real(sorted(4)) + real(sorted(5))) / 3)
            if((count_first .eq. sorted(1)) .and. (count_second .eq. sorted(5)) .and. (sorted(1) .ne. sorted(5))) then
                scores = sorted(1) + sorted(2) + sorted(3) + sorted(4) + sorted(5)
            end if
        case ("four of a kind")
             sorted = sort(dice)
             count_first = nint((real(sorted(1)) + real(sorted(2)) + real(sorted(3)) + real(sorted(4))) / 4)
             if(count_first .eq. sorted(1)) then
                 scores = sorted(1) + sorted(2) + sorted(3) + sorted(4)
             end if
             count_first = nint((real(sorted(2)) + real(sorted(3)) + real(sorted(4)) + real(sorted(5))) / 4)
             if(count_first .eq. sorted(2)) then
                 scores = sorted(2) + sorted(3) + sorted(4) + sorted(5)
             end if
        case ("little straight")
            sorted = sort(dice)
            if((sorted(1) .eq. 1) .and. (sorted(2) .eq. 2) .and. (sorted(3) .eq. 3) .and. &
               (sorted(4) .eq. 4) .and. (sorted(5) .eq. 5)) then
                scores = 30
            end if 
        case ("big straight")
            sorted = sort(dice)
            if((sorted(1) .eq. 2) .and. (sorted(2) .eq. 3) .and. (sorted(3) .eq. 4) .and. &
               (sorted(4) .eq. 5) .and. (sorted(5) .eq. 6)) then
                scores = 30
            end if 
        case ("choice")
            sorted = sort(dice)
            scores = sorted(1) + sorted(2) + sorted(3) + sorted(4) + sorted(5)
        case ("yacht")
            sorted = sort(dice)
            count_first = nint((real(sorted(1)) + real(sorted(2)) + real(sorted(3)) + real(sorted(4)) + real(sorted(5))) / 5)
            if(count_first .eq. sorted(1)) then
                scores = 50
            end if
        case default
             scores = 0
    end select
    score = scores
  end function

  integer function get_scores(dice, num)
      integer, dimension(5), intent(in) :: dice
      integer, intent(in) :: num
      integer :: i, scores
      scores = 0
      do i = 1, 5
          if(dice(i) == num) then
              scores = scores + 1
          end if
      end do
      get_scores = scores * num
  end function 

  function sort(dice)
      integer, dimension(5), intent(in) :: dice
      integer, dimension(5) :: sort
      integer :: i, j, min_index, temp
      sort = dice
      do i = 1, 5
          min_index = i
          do j = (i + 1), 5
              if(sort(min_index) > sort(j)) then
                  min_index = j
              end if
          end do        
          temp = sort(min_index)
          sort(min_index) = sort(i)
          sort(i) = temp
      end do
  end function
  
end module
