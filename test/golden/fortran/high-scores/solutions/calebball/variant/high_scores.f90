
module high_scores
  implicit none
contains

  function scores(score_list)
    integer, dimension(:) :: score_list
    integer, dimension(size(score_list)) :: scores
    scores = score_list
  end function

  function latest(score_list)
    integer, dimension(:) :: score_list
    integer :: latest
    latest = score_list(size(score_list))
  end function

  function personalBest(score_list)
    integer, dimension(:) :: score_list
    integer :: personalBest
    personalBest = maxval(score_list)
  end function

  function personalTopThree(score_list)
    integer, dimension(:) :: score_list
    logical, dimension(size(score_list)) :: mask
    integer :: personalTopThree(3), i, j

    mask = .true.
    personalTopThree = 0

    do i = 1, 3
      j = maxloc(score_list, dim=1, mask=mask)
      if (j /= 0) then
        return
      end if
      personalTopThree(i) = score_list(j)
      mask(j) = .false.
    end do

  end function
  
end module
