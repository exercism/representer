.equ INVALID_NUMBER, -1

.text
.globl steps

steps:
        cmp X0, #1
        b.lt .error
        mov X3, #3 // for multiplication
        mov X1, #0
.loop:
        cmp X0, #1
        b.eq .done
        tst X0, #1
        b.eq .is_even
        b .is_odd
.is_even:
        lsr X0, X0, #1
        add X1, X1, #1
        b .loop
.is_odd:
       mul X0, X0, X3
       add X0, X0, #1
       add X1, X1, #1
       b .loop
.done:
        mov X0, X1
        ret
.error:
        mov X0, INVALID_NUMBER
        ret
