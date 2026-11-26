.equ DEFICIENT, 1
.equ PERFECT, 2
.equ ABUNDANT, 4
.equ INVALID, -1

.text
.globl classify

classify:
        cmp x0,#0
        b.gt valid
        mov x0,INVALID
        ret
valid:
        cmp x0,#2
        b.gt not2
        mov x0,DEFICIENT
        ret
not2:   
        mov x1,#1
        mov x2,#2
        lsr x5,x0,#1
mainloop:
        udiv x4,x0,x2
        msub x4,x4,x2,x0 // x3 = x0  - x4*x3
        cbz x4,zerorem
        b.al nextval
zerorem:
        add x1,x1,x2
nextval:
        add x2,x2,#1
        cmp x2,x5
        b.le mainloop

        cmp x1,x0
        b.gt abundant
        b.lt deficient
        mov x0,PERFECT
        ret
abundant:
        mov x0,ABUNDANT
        ret
deficient:
        mov x0,DEFICIENT
        ret
