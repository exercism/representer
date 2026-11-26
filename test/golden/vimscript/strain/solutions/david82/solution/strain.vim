"
" Given a list and a predicate working on each element, returns a new list
" of those elements satisfying the predicate
"
function! Keep(list, predicate) abort
  let result = []
  for item in a:list
    if call(a:predicate, [item])
      call add(result, item)
    endif
  endfor
  return result
endfunction

"
" Given a list and a predicate working on each element, returns a new list
" of those elements not satisfying the predicate
"
function! Discard(list, predicate) abort
  let result = []
  for item in a:list
    if !call(a:predicate, [item])
      call add(result, item)
    endif
  endfor
  return result
endfunction
