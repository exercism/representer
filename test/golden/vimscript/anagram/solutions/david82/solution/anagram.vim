"
" Given a word and a list of possible anagrams, select the correct sublist.
"
" Example:
"
"   :echo FindAnagrams(['foo', 'bar', 'oof', 'Ofo'], 'foo')
"   ['Ofo', 'oof']
"
function! FindAnagrams(candidates, subject) abort
  " Helper function to sort the characters of a string
  function! s:SortString(str)
    let l = split(a:str, '\zs')
    call sort(l)
    return join(l, '')
  endfunction

  " Normalize the subject by sorting its characters
  let normalized_subject = s:SortString(tolower(a:subject))
  let result = []

  " Iterate through the candidates to find anagrams
  for candidate in a:candidates
    " Skip if candidate is the same as subject (case insensitive)
    if tolower(candidate) == tolower(a:subject)
      continue
    endif
    " Normalize the candidate
    let normalized_candidate = s:SortString(tolower(candidate))
    " Add to result if it's an anagram
    if normalized_candidate == normalized_subject
      call add(result, candidate)
    endif
  endfor

  return result
endfunction
