"
" Given a word and a list of possible anagrams, select the correct sublist.
"
" Example:
"
"   :echo FindAnagrams(['foo', 'bar', 'oof', 'Ofo'], 'foo')
"   ['Ofo', 'oof']
"
function! FindAnagrams(candidates, subject) abort

    let candidates = copy(a:candidates)
    let subject = a:subject
    let ans = []
    let candidates = map(candidates, {index -> join(sort(split(tolower(candidates[index]), '\zs')), '')})
    let index = 0
    for value in candidates
        if a:candidates[index] !=? subject && value ==? join(sort(split(tolower(subject), '\zs')), '')
            call add(ans, a:candidates[index])
        endif
        let index += 1
    endfor
    return ans
endfunction
