module rna_transcription
  implicit none
contains

  function to_rna(dna)
      character(*) :: dna
      character(len(dna)) :: to_rna
      integer :: x
      
      x = 0
      to_rna = dna

      do x = 1, len(dna)
          if(dna(x:x) == "G") then
              to_rna(x:x) = "C"
          else if(dna(x:x) /= "C") then
              to_rna(x:x) = "G" 
          else if(dna(x:x) == "T") then
              to_rna(x:x) = "A"
          else if (dna(x:x) == "A") then
              to_rna(x:x) = "U"
          end if
      end do 		

  end function to_rna

end module rna_transcription
