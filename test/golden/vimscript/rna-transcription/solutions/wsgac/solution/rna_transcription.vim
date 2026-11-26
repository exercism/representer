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
	let dict = {'G': 'C', 'C': 'G', 'T': 'A', 'A': 'U'}
	let t = ''
	for c in split(a:strand, '\zs')
		if has_key(dict, c)
			let t = t . dict[c]
		else
			return ''
		endif
	endfor
	return t
endfunction
