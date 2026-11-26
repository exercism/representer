.section .rodata
fmt_with_name:    .asciz "One for %s, one for me."
default_name:     .asciz "you"

.text
.globl two_fer
two_fer:
        stp     x29, x30, [sp, #-32]!
        mov     x29, sp
        str     x19, [sp, #16]
        
        mov     x19, x0
        cmp     x1, #0
        bne     __has_name
        adr     x1, default_name
__has_name:
        mov     x2, x1
        mov     x0, x19
        adr     x1, fmt_with_name
        bl      sprintf
        ldr     x19, [sp, #16]
        ldp     x29, x30, [sp], #32
        ret
        