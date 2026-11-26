.text
.globl egg_count

egg_count:
        mov x1, xzr // egg count
        mov x2, #2 // bitmask
        mov x3, #63 // running var

loop:
        and x4, x0, x2 // filter bit with mask
        cmp x4, xzr // compare with zero
        b.eq noegg
        add x1, x1, #1 // increment count if 1
noegg:
        cmp x3, xzr // end of loop
        b.eq end
        
        sub x3, x3, #1 // decrement running var
        lsl x2, x2, #1 // shift bitmask
        b loop
end:
        mov x0, x1
        ret
