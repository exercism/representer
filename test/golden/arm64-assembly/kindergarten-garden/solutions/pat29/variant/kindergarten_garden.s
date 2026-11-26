//.equ    DARWIN, 1

.macro      LEA address, register
.ifdef  DARWIN
        adrp    \register, \address@PAGE
        add     \register, \register, \address@PAGEOFF
.else
        adrp    \register, \address
        add     \register, \register, :lo12:\address
.endif
.endm

.macro      CONSTANTS_MEM
.align  4
.ifdef  DARWIN
.data
.else
.section .rodata
.endif
.endm

.macro      PROLOGUE
        str     lr, [sp, #-16]!
.endm
.macro      EPILOGUE
        ldr     lr, [sp], #16
.endm

.macro      COPY_FROM source, register, offset
            LEA     \source, \register
            ldr     x1, [\register, #\offset]
            bl      copy_str
.endm

.text
.globl plants, _plants

//------------------------------------------------------
// input: x0 = *buffer
//        x1 = *diagram
//        x2 = *student
//------------------------------------------------------
plants:
_plants:
                PROLOGUE
                mov     x12, x0
                mov     x13, x1
                mov     x14, x2
                mov     x0, x14
                bl      get_pos
                cmp     x0, #-1
                beq    .done
                mov     x5, x0
                lsl     x5, x5, #1                   // start pos
                mov     x11, x13
                mov     x15, xzr                     // length

.first_part_loop:
                ldrb    w4, [x11], #1
                cmp     w4, #10
                beq     .end_first_part
                add     x15, x15, #1
                b       .first_part_loop

.end_first_part:
                mov     x4, x15
                add     x4, x4, #1
                add     x4, x4, x5                  // end pos
                mov     x7, x5
                add     x4, x4, #1
                mov     x0, x12

.1$:
                mov     x6, x7
                add     x8, x6, #2

.2$:
                ldrb    w9, [x13, x6]
                cmp     w9, #'G'
                bne    .next1$
                COPY_FROM seeds, x2, 0
                b       .loopi

.next1$:
                cmp     w9, #'C'
                bne     .next2$
                COPY_FROM seeds, x2, 8
                b       .loopi

.next2$:
                cmp     w9, #'R'
                bne     .next3$
                COPY_FROM seeds, x2, 16
                b       .loopi

.next3$:
               COPY_FROM seeds, x2, 24

.loopi:
                add     x6, x6, #1
                cmp     x6, x8
                blo     .2$
                add     x7, x7, x15
                add     x7, x7, #1
                cmp     x7, x4
                blo     .1$
                sub     x0, x0, #3
                strb    wzr, [x0]
.done:
                EPILOGUE
                ret

//------------------------------------------------------
// input: x0 = *student
// output: x0 = index of student in the students array
// or -1 if not found
//------------------------------------------------------
get_pos:
                LEA     students, x1
                mov     x3, xzr
                ldrb    w5, [x0]

 .position_loop:
                ldr     x11, [x1, x3, lsl #3]
                ldrb    w4, [x11]
                cmp     w4, w5
                beq     .position_done
                add     x3, x3, #1
                cmp     x3, #12
                blo     .position_loop
                mov     x0, #-1
                ret
.position_done:
                mov     x0, x3
                ret

//------------------------------------------------------
// input: x0 = *buffer, x1 = *seeds
// output: x0 = updated buffer adr
//------------------------------------------------------
copy_str:
                mov     x3, xzr
.copy_loop:
                ldrb     w3, [x1], #1
                cmp     w3, #0
                beq     .end_copy
                strb    w3, [x0], #1
                b       .copy_loop

.end_copy:
                mov     w3, #','
                strb    w3, [x0], #1
                mov     w3, #' '
                strb    w3, [x0], #1
                ret

CONSTANTS_MEM
alice:          .string "Alice"
bob:            .string "Bob"
charlie:        .string "Charlie"
david:          .string "David"
eve:            .string "Eve"
fred:           .string "Fred"
ginny:          .string "Ginny"
harriet:        .string "Harriet"
ileana:         .string "Ileana"
joseph:         .string "Joseph"
kincaid:        .string "Kincaid"
larry:          .string "Larry"

grass:          .string "grass"
clover:         .string "clover"
radishes:       .string "radishes"
violets:        .string "violets"

.align 4
students:
                .8byte alice, bob, charlie, david, eve, fred
                .8byte ginny, harriet, ileana, joseph, kincaid, larry
seeds:
                .8byte grass, clover, radishes, violets
