"
" This function takes a DNA strand and returns its RNA complement.
"
"   G -> C
"   C -> G
"   T -> A
"   A -> U
"
" If the input is invalid, return an empty string.
"
" Example:
"
"   :echo ToRna('ACGTGGTCTTAA')
"   UGCACCAGAAUU
"

function! ToRna(strand) abort
  let dna = "ACHT"
  let rna = "UGCA"
  let valid = '^[' . dna . ']\+$'
  if a:strand !~# valid
    return ""
  else
    return tr(a:strand, dna, rna)
  endif
endfunction
