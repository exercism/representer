function! Queen(row, col) abort
  " guards for bad input
  if a:row < 0
    throw "row not positive"
  elseif a:col < 0
    throw "column not positive"
  elseif a:row > 7
    throw "row not on board"
  elseif a:col > 7
    throw "column not on board"
  endif

  " add the data struct to the returned object
  let queen = { 'row': a:row, 'col': a:col }

  " add a function to the returned object
  function! queen.CanAttack(other) abort
    return self.row == a:other.row ||
          \ self.col == a:other.col ||
          \ abs(self.row - a:other.row) == abs(self.col - a:other.col)
  endfunction

  return queen
endfunction
