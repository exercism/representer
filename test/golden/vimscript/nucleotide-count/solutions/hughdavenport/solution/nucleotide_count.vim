"
" Given a DNA string, compute how many times each nucleotide occurs in the
" string.
"
" Examples:
"
"   :echo NucleotideCounts('ACGTACGT')
"   {'A': 2, 'C': 2, 'T': 2, 'G': 2}
"
"   :echo NucleotideCounts('ACGTXACGT')
"   E605: Exception not caught: Invalid nucleotide in strand
"

"source ../common.vim

function! NucleotideCounts(strand) abort
"  call TypeCheck(a:strand, '')
  if match(a:strand, '\v[^ACGT\v]') != -1
    throw 'Invalid nucleotide in strand'
  endif

  let l:ret = #{A: 0, C: 0, G: 0, T: 0}
  for l:c in split(a:strand, '\zs')
    let l:ret[l:c] += 1
  endfor

"  call TypeCheck(l:ret, #{A: 1})
  return l:ret
endfunction
