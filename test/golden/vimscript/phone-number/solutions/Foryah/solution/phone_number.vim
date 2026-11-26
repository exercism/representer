function! ToNANP(number) abort
  let clean_number = substitute(a:number, '\D', '', 'g')

  " If the first char is 1, it's the country code
  if l:clean_number[0] ==# '1'
    let clean_number = strcharpart(l:clean_number, 1)
  endif

  " Number must be exactly 10 char long
  if len(l:clean_number) != 10
    return ''
  endif

  " 1st and 4th chars must be >= 2
  let first_char = str2nr(l:clean_number[0])
  let fourth_char = str2nr(l:clean_number[3])
  if l:first_char < 2 || l:fourth_char < 2
    return ''
  endif

  return l:clean_number
endfunction
