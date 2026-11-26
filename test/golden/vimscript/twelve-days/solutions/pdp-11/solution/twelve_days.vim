function! s:Sentence(n) abort
	let l:ord = ['none', 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth']
	let l:items = ['nothing', 'a Partridge in a Pear Tree', 'two Turtle Doves', 'three French Hens', 'four Calling Birds', 'five Gold Rings', 'six Geese-a-Laying', 'seven Swans-a-Swimming', 'eight Maids-a-Milking', 'nine Ladies Dancing', 'ten Lords-a-Leaping', 'eleven Pipers Piping', 'twelve Drummers Drumming',]
	let l:r = 'On the '.. l:ord[a:n] ..' day of Christmas my true love gave to me: '
	if a:n < 2 | return l:r .. l:items[a:n] .. '.' | endif
	for l:i in range(a:n, 2, -1)
		let l:r .= l:items[l:i] .. ', '
	endfor
	return l:r .. 'and ' .. l:items[1] .. '.'
endfunction

function! Recite(start, end) abort
	return reduce(range(a:start, a:end), {r, i -> r + [s:Sentence(i)]}, [])->join('\n')
endfunction
