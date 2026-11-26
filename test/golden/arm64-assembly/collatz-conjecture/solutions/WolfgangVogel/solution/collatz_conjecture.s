.equ INVALID_NUMBER, -1

stepCounter .req x1
remainder .req x2

.text
.globl steps

steps:
        cmp x0, #1
        b.lt invalid

        mov stepCounter, #0

loop:
        cmp x0, #1
        b.eq done
        
        ands remainder, x0, #1
        b.eq even
        b odd

even:
        lsr x0, x0, #1
        
        add stepCounter, stepCounter, #1
        b loop

odd:
        add x0, x0, x0, lsl #1
        add x0, x0, #1
        
        add stepCounter, stepCounter, #1
        b loop

done:
        mov x0, stepCounter
        ret

invalid:
        mov x0, INVALID_NUMBER
        ret