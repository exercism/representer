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
  " your solution goes here
	let i = 0
	let res = ''
	while i < strlen(a:strand)
		if a:strand[i] == 'G'
			let res = res . 'C'
		elseif a:strand[i] == 'C'
			let res = res . 'G'
		elseif a:strand[i] == 'T'
			let res = res . 'A'
		elseif a:strand[i] == 'A'
			let res = res . 'U'
		else
			return ''
		endif
		let i = i + 1
	endwhile
	return res

endfunction
