"
" Given a list and a predicate working on each element, returns a new list
" of those elements satisfying the predicate
"
function! Keep(list, predicate) abort
  let out = []
  for x in a:list
    if a:predicate(x)
      call add(out, x)
    endif
  endfor
  return out
endfunction

"
" Given a list and a predicate working on each element, returns a new list
" of those elements not satisfying the predicate
"
function! Discard(list, predicate) abort
  return Keep(a:list, {x -> !a:predicate(x)})
endfunction
