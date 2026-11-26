"
" Determine if a sentence is a pangram.
"
" A pangram is a sentence using every letter of the alphabet at least once.
"
" The alphabet used consists of ASCII letters a to z, inclusive, and is case
" insensitive. Input will not contain non-ASCII symbols.
"
" Example:
"
"     :echo IsPangram('The quick brown fox jumps over the lazy dog')
"     1
"     :echo IsPangram('The quick brown fox jumps over the lazy do')
"     0
"

"source ../common.vim

function! IsPangram(sentence) abort
"  call TypeCheck(a:sentence, '')

  let l:ret = a:sentence->tolower()->substitute('\L', '', 'g')->
             \split('\zs')->sort()->uniq()->len() == 26

"  call TypeCheck(l:ret, 0)
  return l:ret
endfunction
