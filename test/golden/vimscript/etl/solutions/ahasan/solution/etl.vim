"
" We are going to do the Transform step of an Extract-Transform-Load.
"
" Example:
"
"   :echo Transform({'1': ['a', 'b'], '2': ['c']})
"   {'a': 1, 'b': 1, 'c': 2}
"

function! Transform(scores)
    let output = {}
    for key in keys(a:scores)
        for val in sort(a:scores[key])
            let output[tolower(val)] = str2nr(key)
        endfor
    endfor
    return output
endfunction
