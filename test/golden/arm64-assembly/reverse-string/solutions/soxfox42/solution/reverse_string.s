.text
.globl reverse

reverse:
        # Find the end of the string
        sub x1, x0, 1
find_loop:
        ldrb w2, [x1, 1]!
        cmp x2, 0
        bne find_loop

        sub x1, x1, 1
        b loop_cond

loop:
        ldrb w2, [x0]
        ldrb w3, [x1]
        strb w2, [x1], -1
        strb w3, [x0], 1
loop_cond:
        cmp x0, x1
        blt loop

        ret
