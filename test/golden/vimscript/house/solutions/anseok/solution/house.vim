"
" Returns a list of verses from the nursery rhyme 'This is the House that Jack Built'
"
let s:pairs = [
\ ['lay in', 'house that Jack built.'], ['ate', 'malt'],
\ ['killed', 'rat'], ['worried', 'cat'], ['tossed', 'dog'],
\ ['milked', 'cow with the crumpled horn'],
\ ['kissed', 'maiden all forlorn'],
\ ['married', 'man all tattered and torn'],
\ ['woke', 'priest all shaven and shorn'],
\ ['kept', 'rooster that crowed in the morn'],
\ ['belonged to', 'farmer sowing his corn'],
\ ['', 'horse and the hound and the horn']]

function! Verse(n) abort
  return join(['This is the', s:pairs[a:n - 1][1]] + range(
  \ a:n - 2, 0, -1)
    \ ->map({_, i -> s:pairs[i]})
    \ ->map({_, p -> 'that ' . p[0] . ' the ' . p[1]}))
endfunction

function! ReciteVerses(startVerse, endVerse) abort
  " your implementation goes here
  return map(range(a:startVerse, a:endVerse), {_, i -> Verse(i)})
endfunction
