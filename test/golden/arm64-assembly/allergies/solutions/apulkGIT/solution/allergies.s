.data


.text
.equ EGGS, 0
.equ PEANUTS, 1
.equ SHELLFISH, 2
.equ STRAWBERRIES, 3
.equ TOMATOES, 4
.equ CHOCOLATE, 5
.equ POLLEN, 6
.equ CATS, 7
.equ MAX_ITEMS, 8

.globl allergic_to
.globl list

allergic_to:
        mov x2,#1
        lsl x3,x2,x0
        tst x3,x1
        b.eq notfound
        mov x0,#1
        ret
notfound:
        mov x0,#0
        ret

list:
        eor x4,x4,x4
        mov x6,#4
mainloop:
        cmp x4,MAX_ITEMS
        b.eq endofloop
        mov x2,#1
        lsl x3,x2,x4
        tst x3,x0
        b.eq listnotfound
        ldr w5,[x1]
        add w5,w5,#1
        str w5,[x1]
        str w4,[x1,x6]
        add x6,x6,#4
listnotfound:
        add x4,x4,#1
        b.al mainloop
endofloop:
        ret
