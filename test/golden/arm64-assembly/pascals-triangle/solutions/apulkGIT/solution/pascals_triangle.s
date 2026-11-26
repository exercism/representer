.text
.globl rows

rows:
        mov x2,#0
        eor x9,x9,x9
        mov x8,#8
mainloop:
        cmp x1,x2
        b.eq end
        mov x4,#0
        add x3,x2,#1
        sub x5,x3,#1
innerloop:
        cmp x4,x3
        b.eq endofinner
        cmp x4,#0
        b.eq one
        cmp x4,x5
        b.eq one
        msub x7,x3,x8,x0
        ldr x6,[x7],#8
        ldr x10,[x7]
        add x6,x6,x10
        str x6,[x0],#8
        add x4,x4,#1
        add x9,x9,#1
        b.al innerloop
one:
        mov x6,#1
        str x6,[x0],#8
        add x4,x4,#1
        add x9,x9,#1
        b.al innerloop
endofinner:
        add x2,x2,#1
        b.al mainloop
end:
        mov x0,x9
        ret
