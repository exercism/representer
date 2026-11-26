.text
.globl factors

/* extern size_t factors(uint64_t *dest, uint64_t value); */
factors:
        mov x2, #2
        mov x3, x0
        mov x0, #0 
loop:
        cmp x1, #1
        b.ls end      
        mul x4, x2, x2
        cmp x1, x4
        b.lo finish_rest
        udiv x4, x1, x2
        mul x4, x4, x2
        cmp x1, x4
        b.eq found_factor
        add x2, x2, #1
        cmp x2, #3
        b.eq loop
        add x2, x2, #1
        b loop
found_factor:
        str x2, [x3], #8
        udiv x1, x1, x2
        add x0, x0, #1
        b loop
finish_rest:
        cmp x1, #1
        b.eq end
        str x1, [x3], #8
        add x0, x0, #1
end:
        ret