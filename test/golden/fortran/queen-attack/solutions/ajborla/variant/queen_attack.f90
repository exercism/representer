! ----------------------------------------------------------------------------
! exercism.org
! Fortran Track Exercise: queen_attack
! Contributed: Anthony J. Borla (ajborla@bigpond.com)
! ----------------------------------------------------------------------------

module queen_attack
  implicit none
contains

  logical function isValid(pos)
    integer, dimension(2) :: pos
    isValid = pos(1) > 0 .and. pos(1) < 9 .and. pos(2) >= 0 .and. pos(2) < 9
  end function

  logical function canAttack(white_pos, black_pos)
    integer, dimension(2) :: white_pos, black_pos
    logical :: isSameFile, isSameRank, isSamePos, onSameDiag
    isSameFile = white_pos(1) == black_pos(1)
    isSameRank = white_pos(2) == black_pos(2)
    isSamePos = isSameFile .and. isSameRank
    onSameDiag = &
      ABS(white_pos(1) - black_pos(1)) == ABS(white_pos(2) - black_pos(2))
    canAttack = &
      (.not. isSamePos) .and. &
      (isSameFile .or. isSameRank .or. onSameDiag)
  end function

end module
