function! FindFewestCoins(cs, n) abort
	if a:n < 0 | throw "target can't be negative" | endif
	let l:r = [{'r': [], 'l': 0}] + repeat([v:null], a:n)
	for l:c in a:cs
		if l:c > a:n | break | endif
		let l:r[l:c] = {'r': [l:c], 'l': 1} 
	endfor
	for l:i in range(1, a:n)
		if l:r[l:i] isnot v:null | continue | endif
		let [l:minl, l:minj] = [a:n / a:cs[0] + 1, 0]
		for l:j in range(1, l:i / 2)
			if l:r[l:j] is v:null || l:r[l:i - l:j] is v:null | continue | endif
			let l:l = l:r[l:j].l + l:r[l:i - l:j].l
			if l:minl > l:l | let [l:minl, l:minj] = [l:l, l:j] | endif
		endfor
		if l:minj != 1
			let l:r[l:i] = {'r': l:r[l:minj].r + l:r[l:i - l:minj].r, 'l': l:minl}
		endif
	endfor
	if l:r[a:n] is v:null | throw "can't make target with given coins" | endif
	return sort(l:r[a:n].r, 'n')
endfunction
