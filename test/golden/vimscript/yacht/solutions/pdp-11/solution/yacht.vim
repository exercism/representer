function! Score(k, ds) abort
	let l:ns = ['zeroes', 'ones', 'twos', 'threes', 'fours', 'fives', 'sixes']
	let l:i = index(l:ns, a:k)
	if l:i > 0 | return l:i * count(a:ds, l:i) | endif

	if a:k == 'choice' | return reduce(a:ds, {r, d -> r + d}, 0) | endif
	if a:k == 'little straight' | return sort(a:ds) == [1, 2, 3, 4, 5] ? 30 : 0 | endif
	if a:k == 'big straight' | return sort(a:ds) == [2, 3, 4, 5, 6] ? 30 : 0 | endif

	let l:t = {}
	for l:d in map(copy(a:ds), {_, x -> string(x)})
		if has_key(l:t, l:d)
			let l:t[l:d] += 1
		else
			let l:t[l:d] = 1
		endif
	endfor
	if a:k == 'yacht' | return len(keys(l:t)) == 1 ? 50 : 0 | endif
	if a:k == 'full house' | return sort(values(l:t)) == [2, 3] ? reduce(a:ds, {r, d -> r + d}, 0) : 0 | endif
	if a:k == 'four of a kind'
		for l:d in keys(l:t)
			if l:t[l:d] >= 4 | return 4 * str2nr(l:d) | endif
		endfor
		return 0
	endif
endfunction
