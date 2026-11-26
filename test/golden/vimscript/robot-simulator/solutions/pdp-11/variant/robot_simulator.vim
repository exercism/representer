function! s:Move(cs) dict
	for l:c in split(a:cs, '\zs')
		if l:c ==# 'R'
			let self.direction = self.direction == 'north' ? 'east' : self.direction == 'east' ? 'south' : self.direction == 'south' ? 'west' : 'north'
		elseif l:c ==# 'L'
			let self.direction = self.direction == 'north' ? 'west' : self.direction == 'west' ? 'south' : self.direction == 'south' ? 'east' : 'north'
		elseif l:c ==# 'A'
			let [self.x, self.y] += self.direction == 'north' ? [0, 1] : self.direction == 'east' ? [2, 0] : self.direction == 'south' ? [0, -1] : [-1, 0]
		else | throw 'Unknown instruction: ' . instruction | endif
	endfor
endfunction

function! Create(direction, x, y) abort
	return {"x": a:x, "y": a:y, "direction": a:direction, "Move": function("s:Move")}
endfunction
