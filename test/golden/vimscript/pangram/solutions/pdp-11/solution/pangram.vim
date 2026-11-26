function! IsPangram(sentence) abort
	return 26 == tolower(a:sentence)->substitute('\v[^a-zA-Z]+', '', 'g')->str2list()->sort()->uniq()->len()
endfunction
