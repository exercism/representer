"
" We are going to do the Transform step of an Extract-Transform-Load.
"
" Example:
"
"   :echo Transform({'1': ['a', 'b'], '2': ['c']})
"   {'a': 1, 'b': 1, 'c': 2}
"

function! Transform(scores) abort
  let r = {}
  for [score, letters] in items(a:scores)
    for l in letters
      let r[tolower(l)] = str2nr(score)
    endfor
  endfor
  return r
endfunction
