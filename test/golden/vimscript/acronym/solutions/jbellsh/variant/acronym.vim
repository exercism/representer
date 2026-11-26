"
" Convert a phrase into an uppercased acronym formed from
" the initial letter of each word, ignoring leading underscores
"
" Examples:
"
"   :echo Abbreviate('First In, First Out')
"   FIFO
"
"   :echo Abbreviate('The Road _Not_ Taken')
"   TRNT
"
function! Abbreviate(phrase) abort
  let words = split(a:phrase, '\s\|-\|_')
  let capital_letters = []

  for word in words
    let capital_letter = toupper(word[1])
    call add(capital_letters, capital_letter)
  endfor

  return join(capital_letters, '')
endfunction
