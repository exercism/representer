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
  " your solution goes here
  let l:rnaStrand = ""
  for s:char in split(a:strand, '\zs')
    let s:charIndex = stridx("ACGT", s:char)
    if s:charIndex < 0
      return ""
    endif
    let l:rnaStrand = l:rnaStrand . "UGCA"[s:charIndex]
  endfor
  return l:rnaStrand
endfunction
