"
" Create an implementation of the atbash cipher, an ancient encryption system
" created in the Middle East.
"
" Examples:
"
"   :echo AtbashEncode('test')
"   gvhg
"
"   :echo AtbashDecode('gvhg')
"   test
"
"   :echo AtbashDecode('gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt')
"   thequickbrownfoxjumpsoverthelazydog
"

function! AtbashDecode(cipher) abort
  return AtbashDecodeEncode(a:cipher,'cipher')
endfunction

function! AtbashEncode(plaintext) abort
  return AtbashDecodeEncode(tolower(a:plaintext),'plain')
endfunction

function! AtbashDecodeEncode(cipher,operation) abort
 let l:cipherKey = AtbashCipherKey()
 let l:cipher = substitute(a:cipher, '\v[^A-Za-z0-9]', '', 'g')
 let l:result = ""
 let l:groupSize = 5
 let l:counter = 1
 for c in split(l:cipher,'\zs')
   if c =~ '\v[^A-Za-z]'
     let l:result .= c
   else
     let l:result .= l:cipherKey[a:operation][c]
   endif
   if a:operation == 'plain' " if we are encoding
     if (l:counter < len(l:cipher)) && ((l:counter % l:groupSize) == 1)
       let l:result .= " "
     endif
     let l:counter += 1
   endif
 endfor 
 return l:result
endfunction

function! AtbashCipherKey() abort
  let l:plainStr = "abcdefghijklmnopqrstuvwxyz"
  let l:plainLen = len(l:plainStr)
  let l:plain = split(l:plainStr,'\zs')
  let l:plainDictionary = {}
  let l:cipherDictionary = {}
  let l:counter = 1
  for c in l:plain
    let l:cipheredC = l:plainStr[l:plainLen - l:counter]
    let l:plainDictionary[c] = l:cipheredC
    let l:cipherDictionary[l:cipheredC] = c
    let l:counter += 1
  endfor
  return { 'plain': l:plainDictionary, 'cipher': l:cipherDictionary}
endfunction
