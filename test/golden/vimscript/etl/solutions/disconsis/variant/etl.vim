"
" We are going to do the Transform step of an Extract-Transform-Load.
"
" Example:
"
"   :echo Transform({'1': ['a', 'b'], '2': ['c']})
"   {'a': 1, 'b': 1, 'c': 2}
"

function! Transform(scores) abort
    let ret = {}
    for score in keys(a:scores)
        for letter in a:scores[score]
            let ret[toupper(letter)] = str2nr(score)
        endfor
    endfor
    return ret
endfunction