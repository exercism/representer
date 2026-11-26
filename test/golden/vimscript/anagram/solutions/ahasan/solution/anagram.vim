"
" Given a word and a list of possible anagrams, select the correct sublist.
"
" Example:
"
"   :echo FindAnagrams(['foo', 'bar', 'oof', 'Ofo'], 'foo')
"   ['Ofo', 'oof']
"
function! FindAnagrams(candidates, subject)
    let subList = sort(split(tolower(a:subject), '\zs'))
    let outList = []
    for acand in a:candidates
        if tolower(acand) !=# tolower(a:subject)
            let acandList = sort(split(tolower(acand), '\zs'))
            if acandList ==# subList
                let outList = add(outList, acand)
            endif
        endif
    endfor
    return outList
endfunction
