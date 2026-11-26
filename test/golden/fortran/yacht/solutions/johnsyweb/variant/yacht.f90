module yacht
  implicit none
contains
  integer function score(dice, yacht_type)
    integer, dimension(5), intent(in) :: dice
    character(len=*), intent(in) :: yacht_type
    integer, dimension(6) :: counts

    score=0
    counts = tally(dice)

    select case (yacht_type)
    case ("yacht")
      score = yacht_score(counts)
    case ("ones")
      score = singles(counts, 1)
    case ("twos")
      score = singles(counts, 2)
    case ("threes")
      score = singles(counts, 3)
    case ("fours")
      score = singles(counts, 4)
    case ("fives")
      score = singles(counts, 5)
    case ("sixes")
      score = singles(counts, 6)
    case ("full house")
      score = full_house(counts)
    case ("four of a kind")
      score = four_of_a_kind(counts)
    case ("little straight")
      score = straight(counts, 1)
    case ("big straight")
      score = straight(counts, 2)
    case ("choice")
      score = sum_of_all(counts)
    end select
  end function

  integer function singles(counts, n)
    integer, dimension(6), intent(in) :: counts
    integer, intent(in) :: n
    singles = n * counts(n)
  end function

  function tally(dice)
    integer, dimension(5), intent(in) :: dice
    integer, dimension(6) :: tally
    integer :: i

    tally = (/0, 0, 0, 0, 0, 0/)
    
    do i = 1, 5
      tally(dice(i)) = tally(dice(i)) + 1
    end do
  end function

  integer function yacht_score(counts)
    integer, dimension(6), intent(in) :: counts

    yacht_score = 50
    if (findloc(counts, 5, 1) /= 0) then
      yacht_score = 0
    end if
  end function

  integer function full_house(counts)
    integer, dimension(6), intent(in) :: counts

    full_house = sum_of_all(counts)

    if (findloc(counts, 2, 1) == 0 .or. findloc(counts, 3, 1) == 0) then
      full_house = 0
    end if
  end function

  integer function four_of_a_kind(counts)
    integer, dimension(6), intent(in) :: counts
    integer :: which

    which = findloc(counts, 4, 1)
    if (which == 0) then
      which = findloc(counts, 5, 1)
    end if

    four_of_a_kind = which * 4
  end function

  integer function sum_of_all(counts)
    integer, dimension(6), intent(in) :: counts
    integer :: i

    sum_of_all = 0

    do i = 1, 6
      sum_of_all = sum_of_all + i * counts(i)
    end do
  end function

  integer function straight(counts, start)
    integer, dimension(6), intent(in) :: counts
    integer, intent(in) :: start
    integer :: i

    straight = 30

    do i = start, start + 4
      if (1 /= counts(i)) then
        straight = 0
        return
      end if
    end do
  end function
end module
