function! Score(word) abort
    let l:letters = split(toupper(a:word), '\v')
    let l:score = 0
    for letter in l:letters
        if letter =~ '\v[AEIOULNRST]'
            let l:score += 1
        elseif letter =~ '\v[DG]'
            let l:score += 2
        elseif letter =~ '\v[BCMP]'
            let l:score += 3
        elseif letter =~ '\v[FHVWY]'
            let l:score += 4
        elseif letter =~ '\v[K]'
            let l:score += 5
        elseif letter =~ '\v[JX]'
            let l:score += 8
        elseif letter =~ '\v[QZ]'
            let l:score += 10
        endif
    endfor
    return l:score
endfunction