function! Modifier(score) abort
  return float2nr(floor((a:score - 10) / 2.0))
endfunction

function! Ability() abort
  " let's write a silly one line
  " we need to:
  " - let's generate four random rolls from 1 to 6
  " - then we sort and discard the lowest one, i.e. index from 1 onwards
  " - sum those valuess
  let l:abilitySum =  reduce(sort(map(repeat([0], 4), '(rand() % 6) + 1'))[2:], { acc, val -> acc + val }, 0)
  return l:abilitySum
endfunction

function! Character() abort
  let l:constitution = Ability()
  return {'strength': Ability(), 
  \       'dexterity': Ability(),
  \       'constitution': l:constitution,
  \       'intelligence': Ability(),
  \       'wisdom': Ability(),
  \       'charisma': Ability(),
  \       'hitpoints': 10 + Modifier(l:constitution)}
endfunction
