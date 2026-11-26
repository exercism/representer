
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
  integer, dimension(3) :: personalTopThree

  logical, dimension(size(score_list)) :: mask
  integer, dimension(1) :: topIdx
  
  personalTopThree(:) = 0

  if (size(score_list) >= 1) then
    mask(:) = .true.
    topIdx = maxloc(score_list, MASK=mask)
    personalTopThree(1) = score_list(topIdx(1))
  
    if (size(score_list) >= 2) then
      mask(topIdx) = .false.
      topIdx = maxloc(score_list, MASK=mask)
      personalTopThree(2) = score_list(topIdx(1))

      if (size(score_list) >= 3) then
        mask(topIdx) = .false.
        topIdx = maxloc(score_list, MASK=mask)
        personalTopThree(3) = score_list(topIdx(1))
      end if
    end if
  end if
end function

end module
