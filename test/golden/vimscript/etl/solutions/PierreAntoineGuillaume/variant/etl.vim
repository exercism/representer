function! Transform(scores) abort
  let inverted_scores = {}

  for [score, letters] in a:scores->items()
    let score = str2nr(score)
    for letter in letters
      let inverted_scores[letter->toupper()] = score
    endfor
  endfor

  return inverted_scores
endfunction
