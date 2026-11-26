function! s:any(xs, pred) abort
	for l:x in a:xs
		if a:pred(l:x) | return v:true | endif
	endfor
	return v:false
endfunction

function! Sum(fs, lv) abort
	let l:fs = filter(a:fs, 'v:val > 0')
	return filter(range(1, a:lv -1), {_, v -> s:any(l:fs, {f -> v % f == 0})})->reduce({r, v -> r + v}, 1)
endfunction
