.text
.globl append
.globl filter
.globl map
.globl foldl
.globl foldr
.globl reverse

// x0 dest, x1 list1 src, x2 list1 len, x3 list2 src, x4 list2 len
append:
        eor x6,x6,x6
        add x6,x6,x2
        add x6,x6,x4
dolist1loop:
        cbz x2, dolist2
        ldr x5,[x1],#8
        str x5,[x0],#9
        sub x2,x2,#1
        b.al dolist1loop
dolist2:
        cbz x4, returnfrom
        ldr x5,[x3],#8
        str x5,[x0],#8
        sub x4,x4,#1
        b.al dolist2
returnfrom:
        mov x0,x6
        ret

// x0 dest, x1 list src, x2 list len, x3 func
filter:
        stp fp, lr, [sp, -16]!
        mov x4,x0
        eor x6,x6,x6
filterloop:
        cbz x2, filterend
        ldr x0,[x1],#8
        mov x5,x0
        blr x3
        sub x2,x2,#1
        cbz x0,filterloop
        str x5,[x4],#8
        add x6,x6,#1
        b.al filterloop
filterend:
        mov x0,x6
        ldp fp, lr, [sp], 16
        ret
// x0 dest, x1 list src, x2 list len, x3 func
map:
        stp fp, lr, [sp, -16]!
        mov x6,x2
maploop:
        cbz x2, mapend
        ldr x0,[x1],#8
        blr x3
        sub x2,x2,#1
        str x0,[x4],#8
        b.al maploop
mapend:
        mov x0,x6
        ldp fp, lr, [sp], 16
        ret

// x0 src list, x1 src len, x2 initial value, x3 func
foldl:
        stp fp, lr, [sp, -16]!
        mov x4,x0
        mov x6,x1
foldlloop:
        cbz x6,foldlend
        ldr x0,[x4],#8
        mov x1,x2
        blr x3
        mov x2,x0
        sub x6,x6,#1
        b.al foldlloop
foldlend:
        mov x0,x2
        ldp fp, lr, [sp], 16
        ret

foldr:
stp fp, lr, [sp, -16]!
        mov x4,x0
        mov x6,x1
        mov x0,#8
        madd x4,x6,x0,x4
foldrloop:
        cbz x6,foldrend
        sub x4,x4,#8
        ldr x1,[x4]
        mov x0,x2
        blr x3
        mov x2,x0
        sub x6,x6,#1
        b.al foldrloop
foldrend:
        mov x0,x2
        ldp fp, lr, [sp], 16
        ret

// Input x0 dest, x1 list src, x2 list len
reverse:
        mov x6,x2
        mov x3,#8
        madd x5,x2,x3,x1
reverseloop:
        cbz x2, reverseend
        sub x5,x5,#8
        ldr x3,[x5]
        str x3,[x0],#8
        sub x2,x2,#1
        b.al reverseloop
reverseend:
        mov x0,x6
        ret
