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
  let dna = 'CGTA'
  let rna = 'GCAU'
  let repl = {}
  for i in range(strlen(dna))
    let repl[dna[i]] = rna[i]
  endfor
  if a:strand =~ '[^'.dna.']'
    return ''
  end
  return substitute(a:strand, '.', '\=repl[submatch(0)]', 'g')
endfunction