module protein_translation
  implicit none

contains

  function proteins(rna) result(names)
    character(len=*), intent(in) :: rna
    character(len=13), allocatable :: names(:),temp(:)
    integer :: codons,i,j
    codons = len(trim(rna))
    allocate(temp(20))
    temp(:)=""
    j = 0
    do i = 1, codons, 3
       j = j + 1
       select case(rna(i:i+2))
          case ("AUG")
               temp(j:j) = "Methionine"
          case ("UUU","UUC")
               temp(j:j) = "Phenylalanine"
          case ("UUA","UUG")
               temp(j:j) = "Leucine"
          case ("UCU","UCC","UCA","UCG")
               temp(j:j) = "Serine"
          case ("UAU","UAC")
               temp(j:j) = "Tyrosine"
          case ("UGU","UGC")
               temp(j:j) = "Cysteine"
          case ("UGG")
               temp(j:j) = "Tryptophan"
          case ("UAA","UAG","UGA")
               j = j - 1
               exit     
       end select
    end do
    allocate(names(j))
    if (j > 0) then
       names(1:j) = temp(1:j)
    end if   
    !names = [character(len=13) :: rna] ! Replace this line in your implementation
  end function proteins

end module protein_translation

