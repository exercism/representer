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

function! NucleotideCounts(strand) abort
  let counts = {'A': 0, 'C': 0, 'G': 0, 'T': 0}

  for nucleotide in split(a:strand, '\zs')
    if has_key(counts, nucleotide)
      let counts[nucleotide] += 1
    else
      throw 'Invalid nucleotide in strand'
    endif
  endfor

  return counts
endfunction
