.equ INVALID_NUMBER, -1

.text
.globl steps

steps:
        mov x1, #0
        cmp x0, #1
        b.lt invalid

loop:
        cmp x0, #1
        b.eq done
        tst x0, #1
        b.eq even

odd:
        mov x3, #3
        mul x0, x0, x3
        add x0, x0, #1
        add x1, x1, #1
        b loop
        
even:
        lsr x0, x0, #1
        add x1, x1, #1
        b loop
        
done:
        mov x0, x1
        ret

invalid:
        mov x0, INVALID_NUMBER
        ret