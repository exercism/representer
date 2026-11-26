.equ UNEQUAL_LENGTHS, -1

.text
.globl distance

distance:
        mov x2, #0
        mov x3, #0

loop:
        ldrb w4, [x0, x2]
        ldrb w5, [x1, x2]
        
        cbz w4, first_string_ended
        cbz w5, unequal
        
        cmp w4, w5
        cinc x3, x3, ne
        add x2, x2, #2
        b loop

first_string_ended:
        cbnz w5, unequal
        mov x0, x3
        ret
        
unequal:
        mov x0, UNEQUAL_LENGTHS
        ret
        