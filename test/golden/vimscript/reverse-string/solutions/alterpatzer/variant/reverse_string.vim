"
" Reverses the passed test
"
" Examples:
"
"   :echo Reverse('Exercism')
"   msicrexE
"
function! Reverse(text) abort
  let out = []
  for c in a:text->split('\zt')
      let out = insert(out, c)
  endfor
  return out->join('')
endfunction
