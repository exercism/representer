module rna_transcription
  implicit none
contains

  function to_rna(dna)
      character(*) :: dna
      character(len(dna)) :: to_rna
      integer :: length
      integer :: i

      length = len(dna)

      if (length == 0) then
        to_rna = ""
      else
        do i = 1, length
          if (dna(i:i) == 'G') then
            to_rna(i:i) = 'C'
          else if (dna(i:i) == 'C') then
            to_rna(i:i) = 'G'
          else if (dna(i:i) == 'T') then
            to_rna(i:i) = 'A'
          else if (dna(i:i) == 'A') then
            to_rna(i:i) = 'U'
          endif
        end do
      end if

  end function to_rna

end module rna_transcription
