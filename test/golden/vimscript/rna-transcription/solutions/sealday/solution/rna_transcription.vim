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
let s:map = #{G: 'C', C: 'G', T: 'A', A: 'U'}
function! ToRna(strand) abort
  let strand = toupper(a:strand)
  if strand =~ '[^GCTA]'
    return ''
  endif
  return join(map(split(strand, '\zs'), { _, c -> s:map[c] }), '')
endfunction
