"
" Flattens an arbitrarily-deep nested array, removing v:null values.
"
" Examples:
"
"   :echo Flatten([])
"   []
"   :echo Flatten([0, 1, 2])
"   [0, 1, 2]
"   :echo Flatten([0, 1, [2, 3, v:null]])
"   [0, 1, 2, 3]
"
function! Flatten(array) abort
  " your implementation goes here
  let l:r = [] | let l:s = [a:array, 0, []]
  while !empty(l:s)
    let [l:a, l:i, l:s] = l:s
    if l:i == len(l:a) | continue | endif
    let l:v = l:a[l:i] | let l:t = type(l:v)
    let l:s = [l:a, l:i + 1, l:s]
    if l:t == v:t_list | let l:s = [l:v, 1, l:s]
    elseif l:t != v:t_none | call add(l:r, l:v) | endif | endwhile
  return l:r
endfunction
