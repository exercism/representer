
function! SortWord(word) abort
    let l:sorted = sort(split(a:word, '\v'))
    return join(l:sorted, '')
endfunction

function! FindAnagrams(candidates, subject) abort
    let l:subject = tolower(a:subject)
    let l:sorted = SortWord(l:subject)
    let l:result = []
    for candidate in a:candidates
        let l:lower = tolower(candidate)
        if (l:lower != l:subject) && (SortWord(l:lower) == l:sorted)
            let l:result = add(l:result, candidate)
        endif
    endfor
    return l:result
endfunction