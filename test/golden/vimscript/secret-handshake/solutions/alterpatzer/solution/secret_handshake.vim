
"
" Returns a list of actions for a secret handshake given a number in binary.
" Each action is determined by a bit in the rightmost five digits.
"
" Example:
"
"   :echo Commands('11111')
"   ['jump', 'close your eyes', 'double blink', 'wink']
"
function! Commands(binary) abort
  let actions = ["wink", "double blink", "close your eyes", "jump"]
  let out = []
  let t = 1
  let b = str2nr(a:binary, 2)
  for i in range(len(actions))
    if and(b, t)
        call add(out, actions[i])
    endif
    let t *= 2
  endfor
  if and(b, 0x10)
     let out = out->reverse()
  endif
  return out   
endfunction
