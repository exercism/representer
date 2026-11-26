.bss
books: .space 1024

.text
.globl total

// Input: x0 books src, x1 price, Output: x8 output price
getbook:
        stp fp, lr, [sp, -16]!
        eor x2,x2,x2
        mov x3,#0
bookloop:
        cmp x3,#5
        b.eq books5
        ldrb w4,[x0,x3]
        cbz  w4,endofbookloop
        add x2,x2,#1
endofbookloop:
        add x3,x3,#1
        b.al bookloop
books5:
        cmp x2,#5
        b.ne booksnotzeronot5
        add x5,x0,#5
        mov x3,#0
        mov x6,#1000
        eor x4,x4,x4
        mov x7,#-1
bookloop2:
        cmp x3,#5
        b.eq nextonbooks5
        ldrb w4,[x0,x3]
        cmp x4,x6
        b.ge donotadd
        mov x6,x4
        mov x7,x3
donotadd:
        sub w4,w4,#1
        strb w4,[x5,x3]
        add x3,x3,#1
        b.al bookloop2
nextonbooks5:
        sub sp,sp,#40
        str x0,[sp]
        str x1,[sp,#8]
        str x5,[sp,#16]
        str x6,[sp,#24]
        str x7,[sp,#32]
        mov x0,x5
        add x1,x1,#3000
        bl getbook
        ldr x0,[sp]
        ldr x1,[sp,#8]
        ldr x5,[sp,#16]
        ldr x6,[sp,#24]
        ldr x7,[sp,#32]
        add sp,sp,#40
        strb w6,[x5,x7]
        sub sp,sp,#16
        str x0,[sp]
        str x8,[sp,#8]
        mov x0,x5
        add x1,x1,#2560
        bl getbook
        mov x9,x8
        ldr x0,[sp]
        ldr x8,[sp,#8]
        add sp,sp,#16
        cmp x8,x9
        b.lt chooseprice1
        mov x8,x9
chooseprice1:
        ldp fp, lr, [sp], 16
        ret
booksnotzeronot5:
        cmp x2,#0
        b.eq returnfrom
        add x5,x0,#5
        mov x3,#0
bookloop3:
        cmp x3,#5
        b.eq nextonbooks1to4
        ldrb w4,[x0,x3]
        cbz w4,donotdec
        sub w4,w4,#1
donotdec:
        strb w4,[x5,x3]
        add x3,x3,#1
        b.al bookloop3
nextonbooks1to4:
        cmp x2,#1
        b.ne not1
        mov x3,#800
        b.al endofswitch
not1:
        cmp x2,#2
        b.ne not2
        mov x3,#1520
        b.al endofswitch
not2:
        cmp x2,#3
        b.ne not3
        mov x3,2160
        b.al endofswitch
not3:
        mov x3,2560
endofswitch:
        mov x0,x5
        add x1,x1,x3
        bl getbook
        ldp fp, lr, [sp], 16
        ret
returnfrom:
        mov x8,x1
        ldp fp, lr, [sp], 16
        ret
    
// Input: x0 size of basket, x1 basket src
total:
        stp fp, lr, [sp, -16]!
        mov x2,x0
        mov x3,x1
        ldr x0,=books
        mov x1,#0
        mov x4,#0
fillloop:
        cmp x1,#5
        b.eq basketloopstart
        strb w4,[x0,x1]
        add x1,x1,#1
        b.al fillloop
basketloopstart:
        mov x1,#0
basketloop:
        cmp x1,x2
        b.eq basketloopdone
        ldrh w4,[x3],#2
        sub x4,x4,#1
        ldrb w5,[x0,x4]
        add w5,w5,#1
        strb w5,[x0,x4]
        add x1,x1,#1
        b.al basketloop
basketloopdone:
        mov x1,#0
        bl getbook
        mov x0,x8
        ldp fp, lr, [sp], 16
        ret
