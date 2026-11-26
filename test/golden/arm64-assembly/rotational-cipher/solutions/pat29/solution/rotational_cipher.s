.macro          IS_ALPHABETIC char, lower, upper
                cmp     \char, #\lower
                cset    x3, hs
                cmp     \char, #\upper
                cset    x4, ls
                ands    x5, x3, x4
.endm

.text
.globl rotate, _rotate

rotate:
_rotate:                                        // x2 = shift_key
                mov     x10, x0                 // x0 = *buffer
                mov     x11, x1                 // x1 = *text
.rotate_loop:
                ldrb    w6, [x11], #1
                cbz     w6, .end_rotate
                IS_ALPHABETIC w6, 'a', 'z'
                mov     x9, x5
                cbz     x9, .upper
                b       .shift_char
.upper:
                IS_ALPHABETIC w6, 'A', 'Z'
                cbz     x5, .no_alpha
.shift_char:
                add     w7, w6, w2              // c + shift_key
                cmp     w7, #'z'
                cset    x8, ls
                ands    x8, x8, x9
                cbnz    x8,  .not_outside
                cmp     w7, #'Z'
                cset    x8, ls
                ands    x8, x8, x5
                cbnz    x8, .not_outside
                sub     w7, w7, #26             // c + shift_key - 26
.not_outside:
                strb    w7, [x10], #1
                b       .rotate_loop
.no_alpha:
                strb    w6, [x10], #1
                b       .rotate_loop
.end_rotate:
                strb    wzr, [x10]
                ret
