"
" This function takes a DNA strand and returns its RNA complement.
"
"   G -> C
"   C -> G
"   T -> A
"   A -> U
"
" If the input is invalid, return an empty string.
"
" Example:
"
"   :echo ToRna('ACGTGGTCTTAA')
"   UGCACCAGAAUU
"
function! ToRna(strand) abort
    const nucmap = { 'G': 'C', 'C': 'G', 'T': 'A', 'A': 'U' }
    let result = ""
    for c in split(a:strand, '\zs')
        try
            let result .= nucmap[c]
        catch /^Vim\%((\a\+)\)\=:E716/
            " Key not found
            return ''
        endtry
    endfor
    return result
endfunction
