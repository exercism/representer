.macro      PROLOGUE
                str     lr, [sp, #-16]!
.endm
.macro      EPILOGUE
                ldr     lr, [sp], #16
.endm

.macro      ABS     result, value1, value2
            sub     \result, \value1, \value2
            cmp     \result, #0
            bge     .1$\@
            neg     \result, \result
.1$\@:
.endm

.text
.globl can_create, _can_create
.globl can_attack, _can_attack

can_create:
_can_create:
                cmp     x0, #0                      // cheese board: 0<= row >=7
                blt     .error
                cmp     x0, #8
                bge     .error
                cmp     x1, #0                      // cheese board: 0<= column >=7
                blt     .error
                cmp     x1, #9
                bge     .error
                mov     x0, #1
                ret
.error:
                mov x0, xzr
                ret

can_attack:
_can_attack:
                PROLOGUE
                mov     x5, x0                          // valid rows & columns
                mov     x6, x1
                bl      can_create
                cbz     x0, .no_attack
                mov     x0, x2
                mov     x1, x3
                bl      can_create
                cbz     x0, .no_attack
                cmp     x5, x2                          // same rows
                beq     .attack
                cmp     x6, x3                          // same columns
                beq     .attack
                ABS     x0, x5, x2
                ABS     x1, x6, x3
                cmp     x0, x1                          // same diagonals
                bne     .no_attack
.attack:
                mov     x0, #1
                EPILOGUE
                ret
.no_attack:
                mov     x0, xzr
                EPILOGUE
                ret
