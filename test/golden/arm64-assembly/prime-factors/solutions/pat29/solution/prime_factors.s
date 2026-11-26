.text
.globl factors, _factors

factors:
_factors:
                mov     x10, x0                 // x10 = *dest
                mov     x2, x1                  // x2 = number = value
                mov     x3, xzr                 // x3 = length
                mov     x4, #2                  // x4 = divisor
.factor_loop:
                mul     x5, x4, x4
                cmp     x5, x2
                bhi     .end_loop
                udiv    x5, x2, x4              // x2 % x4
                msub    x5, x5, x4, x2
                cmp     x5, #0
                bne     .no_prime
                str     x4, [x10, x3, lsl #3]
                add     x3, x3, #1
                udiv    x2, x2, x4
                b       .factor_loop
.no_prime:
                add     x4, x4, #1
                b       .factor_loop
.end_loop:
                cmp     x2, #1                  // x2 > 1
                bls     .done
                str     x2, [x10, x3, lsl #3]
                add     x3, x3, #1
.done:
                mov x0, x3
                ret
