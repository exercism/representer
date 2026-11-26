
function! BinarySearch(list, value, low, high)
    if a:high < a:low
        throw "value not in list"
    endif

    let l:middle = (a:low + a:high) / 2

    if a:list[l:middle] < a:value
        return BinarySearch(a:list, a:value, l:middle + 1, a:high)
    endif

    if a:value < a:list[l:middle]
        return BinarySearch(a:list, a:value, a:low, l:middle - 1)
    endif

    return l:middle
endfunction

function! Find(list, value) abort
    return BinarySearch(a:list, a:value, 0, len(a:list) - 1)
endfunction

