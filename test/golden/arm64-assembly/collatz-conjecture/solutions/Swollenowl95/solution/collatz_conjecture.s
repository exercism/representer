.equ INVALID_NUMBER, -1

.text
.globl steps

steps:
        cmp     x0, #1
        blt     invalid          
        mov     x1, #0           

loop:
        cmp     x0, #1
        beq     done
        add     x1, x1, #1
        tbz     x0, #0, even_case

odd_case:
        add     x0, x0, x0, lsl #1   // 3n
        add     x0, x0, #1           // 3n + 1
        b       loop

even_case:
        lsr     x0, x0, #1
        b       loop

done:
        mov     x0, x1
        ret

invalid:
        mov     x0, #INVALID_NUMBER
        ret