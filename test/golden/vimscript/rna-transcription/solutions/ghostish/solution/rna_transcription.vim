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
	let l:complement = {
		\'G':'C',
		\'C':'G',
		\'A':'U',
		\'T':'A',
        \}
	let l:res = join(map(range(strlen(a:strand)), {i -> get(l:complement, a:strand[i], "")}), "")
    if strlen(l:res) == strlen(a:strand)
        return l:res
    else
        return ""
    endif
endfunction
