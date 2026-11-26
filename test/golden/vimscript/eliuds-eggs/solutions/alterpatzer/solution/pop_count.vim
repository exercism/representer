"
" Given a base-ten number, compute how many 1 bits are present
"
" Examples:
"
"   :echo EggCount(0)
"   0
"
"   :echo EggCount(16)
"   1
"
function! EggCount(num) abort
    let n = a:num
    let eggs = 0
    while n != 0
       let eggs += 1
       let n = and(n, n - 1)
    endwhile
    return eggs
endfunction
