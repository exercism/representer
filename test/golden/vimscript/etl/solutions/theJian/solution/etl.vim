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
    for k in keys(a:scores)
        for v in a:scores[k]
            let ret[tolower(v)] = +k
        endfor
    endfor
    return ret
endfunction
