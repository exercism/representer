.bss
dominoes: .space 1024

.text
.globl can_chain

// Input: x0 src dominoes len, x1 src dominoes src, x2 first, x3 next, Output: x4 res (boolean)
checkchain:
        stp fp, lr, [sp, -16]!
        cbnz x0,notzerolen
        cmp x2,x3
        b.ne ccnotfound
        mov x4,#1
        ldp fp, lr, [sp], 16        
        ret
ccnotfound:
        mov x4,#0
        ldp fp, lr, [sp], 16
        ret
notzerolen:
        mov x6,#0
dominoloop:
        cmp x6,x0
        b.ge endofchain
        lsl x7,x6,#2
        ldrh w8,[x1,x7]
        cmp w8,w3
        b.ne nextdomino        

        mov x5,#0
        mov x8,x1
        lsl x4,x0,#2
        add x4,x1,x4
        mov x10,x4
copyloop2:
        cmp x5,x0
        b.eq endofcopyloop2
        cmp x5,x6
        b.eq notadd2
        ldr w9,[x8]
        str w9,[x4],#4
notadd2:
        add x8,x8,#4
        add x5,x5,#1
        b.al copyloop2
endofcopyloop2:

        sub sp,sp,#32
        str x0,[sp]
        str x1,[sp,#8]
        str x3,[sp,#16]
        str x6,[sp,#24]
        add x7,x7,#2
        ldrsh w3,[x1,x7]
        sub x0,x0,#1
        mov x1,x10
        bl checkchain
        ldr x0,[sp]
        ldr x1,[sp,#8]
        ldr x3,[sp,#16]
        ldr x6,[sp,#24]
        add sp,sp,#32
        cmp x4,#1
        b.ne nextdomino
        ldp fp, lr, [sp], 16
        ret
nextdomino:
        lsl x7,x6,#2
        add x7,x7,#2
        ldrh w8,[x1,x7]
        cmp w8,w3
        b.ne endofdominoloop
        
        mov x5,#0
        mov x8,x1
        lsl x4,x0,#2
        add x4,x1,x4
        mov x10,x4
copyloop3:
        cmp x5,x0
        b.eq endofcopyloop3
        cmp x5,x6
        b.eq notadd3
        ldr w9,[x8]
        str w9,[x4],#4
notadd3:
        add x8,x8,#4
        add x5,x5,#1
        b.al copyloop3
endofcopyloop3:

        sub sp,sp,#32
        str x0,[sp]
        str x1,[sp,#8]
        str x3,[sp,#16]
        str x6,[sp,#24]
        sub x7,x7,#2
        ldrsh w3,[x1,x7]
        sub x0,x0,#1
        mov x1,x10
        bl checkchain
        ldr x0,[sp]
        ldr x1,[sp,#8]
        ldr x3,[sp,#16]
        ldr x6,[sp,#24]
        add sp,sp,#32
        cmp x4,#1
        b.ne endofdominoloop
        ldp fp, lr, [sp], 16
        ret
endofdominoloop:
        add x6,x6,#1        
        b.al dominoloop
endofchain:
        mov x4,#0
        ldp fp, lr, [sp], 16
        ret

// Input x0 src len, x1 src
can_chain:
        cbz x0,notfound
        stp fp, lr, [sp, -16]!
        eor x2,x2,x2
        eor x3,x3,x3
        ldrsh w2,[x1]
        ldrsh w3,[x1,#2]
        ldr x4,=dominoes
        mov x7,#0
        mov x5,#0
copyloop1:
        cmp x5,x0
        b.eq endofcopyloop1
        cmp x5,x7
        b.eq notadd1
        ldr w6,[x1]
        str w6,[x4],#4
notadd1:
        add x1,x1,#4
        add x5,x5,#1
        b.al copyloop1
endofcopyloop1:
        ldr x1,=dominoes
        sub x0,x0,#1
        bl checkchain
        mov x0,x4
        ldp fp, lr, [sp], 16
        ret
notfound:
        mov x0,#1
        ret
