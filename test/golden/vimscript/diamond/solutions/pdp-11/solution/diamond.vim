function! Rows(c) abort
	let [l:n, l:r] = [char2nr(a:c) - 65, []]
	for l:i in range(l:n + 1)
		let l:l = repeat(' ', l:n - l:i) . nr2char(l:i + 65) . repeat(' ', l:i)
		let l:l .= reverse(l:l[:-2])
		call add(l:r, l:l)
	endfor
	return join(l:r + reverse(l:r[:-2]), '\n')
endfunction
