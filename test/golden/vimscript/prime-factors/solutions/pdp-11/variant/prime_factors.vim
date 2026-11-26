function! Factors(n) abort
	let [l:r, l:n] = [[], a:n]
	let [l:i, l:di] = (a:n % 2 == 0 ? [2, 1] : [3, 3])
	while l:n > 1
		while l:n % l:i == 0
			let l:r += [l:i]
			let l:n /= l:i
		endwhile
		let l:i += l:di
	endwhile
	return l:r
endfunction
