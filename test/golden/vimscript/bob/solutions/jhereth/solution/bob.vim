"
" This function takes any remark and returns Bob's response.
"
function! Response(remark) abort
  let l:remark = trim(a:remark)
  if l:remark == "" | return "Fine. Be that way!" | endif
  let state = 0
  if l:remark == toupper(l:remark) && l:remark =~ '\a' | let state += 1 | endif
  if l:remark[-1:] =~ "?" | let state += 2 | endif
  return {
	\ 0: "Whatever.",
	\ 1: "Whoa, chill out!",
	\ 2: "Sure.",
	\ 3: "Calm down, I know what I'm doing!"}[state]
endfunction
