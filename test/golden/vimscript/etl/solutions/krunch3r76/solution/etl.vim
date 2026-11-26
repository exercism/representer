"
" We are going to do the Transform step of an Extract-Transform-Load.
"
" Example:
"
"   :echo Transform({'1': ['a', 'b'], '2': ['c']})
"   {'a': 1, 'b': 1, 'c': 2}
"

function! Transform(scores) abort
  " your code goes here
  let l:scoresNew = {}
  for [l:key,l:val] in items(a:scores)
		for l:element in l:val
			let l:scoresNew[tolower(l:element)] = l:key+0
		endfor
  endfor
  return l:scoresNew
endfunction
