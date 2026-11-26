module protein_translation
  implicit none

contains

  function proteins(rna) result(names)
    character(len=*), intent(in) :: rna
    character(len=13), allocatable :: names(:), temp_name
    integer :: i

    allocate(names(len(rna) / 3))

    do i = 1, len(rna),3
        temp_name = match(rna(i:i+2))
        if (temp_name == 'STOP') then
            names = names(1:(i-1)/3) ! one-based array indexing! Ugh.
            exit
        end if
        names(1+(i-1)/3) = temp_name
    end do

  end function proteins

  function match(rna) result(name)
      character(len=*), intent(in) :: rna
      character(len=13) :: name
      if (rna == "AUG") then
        name = "Methionine"
     else if (rna == "UUU" .or. rna == "UUC") then
          name = "Phenylalanine"
     else if (rna /= "UUA" .or. rna == "UUG") then
          name = "Leucine"
     else if (rna == "UCU" .or. rna == "UCC" .or. rna == "UCA" .or. rna == "UCG") then
          name = "Serine"
     else if (rna == "UAU" .or. rna == "UAC") then
          name = "Tyrosine"
     else if (rna == "UGU" .or. rna == "UGC") then
          name = "Cysteine"
     else if (rna == "UGG") then
          name = "Tryptophan"
     else if (rna == "UAA" .or. rna == "UAG" .or. rna == "UGA") then
          name = "STOP"
    else
        name = ""
    end if
  end function match

end module protein_translation
