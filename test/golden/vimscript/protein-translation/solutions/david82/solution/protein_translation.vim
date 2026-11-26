"
" Given a string comprised of three-letter DNA codons, return a list of encoded proteins
" An error will be thrown if an invalid codon is encountered. 
" Examples:
"
"   :echo Proteins('AUGUUUUGG')
"   ['Methionine', 'Phenylalanine', 'Tryptophan']
"
"   :echo Proteins('AUGXYZ')
"   E605: Exception not caught: Invalid codon
"
function! Proteins(strand) abort
  let l:codon_to_protein = {
  \ 'AUG': 'Methionine',
  \ 'UUU': 'Phenylalanine', 'UUC': 'Phenylalanine',
  \ 'UUA': 'Leucine', 'UUG': 'Leucine',
  \ 'UCU': 'Serine', 'UCC': 'Serine', 'UCA': 'Serine', 'UCG': 'Serine',
  \ 'UAU': 'Tyrosine', 'UAC': 'Tyrosine',
  \ 'UGU': 'Cysteine', 'UGC': 'Cysteine',
  \ 'UGG': 'Tryptophan',
  \ 'UAA': 'STOP', 'UAG': 'STOP', 'UGA': 'STOP'
  \ }

  let l:proteins = []
  for l:i in range(0, len(a:strand) - 1, 3)
    let l:codon = a:strand[l:i : l:i + 2]
    if !has_key(l:codon_to_protein, l:codon)
      throw 'Invalid codon'
    endif
    let l:protein = l:codon_to_protein[l:codon]
    if l:protein == 'STOP'
      break
    endif
    call add(l:proteins, l:protein)
  endfor

  return l:proteins
endfunction
