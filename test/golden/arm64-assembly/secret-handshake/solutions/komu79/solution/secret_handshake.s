.section .rodata
.balign 32
actions:        // 32-byte stride, indexed by bit number
        .string "wink, "
        .balign 32
        .string "double blink, "
        .balign 32
        .string "close your eyes, "
        .balign 32
        .string "jump, "

.text
.globl commands

buffer          .req x0
number          .req x1
src             .req x2
ch              .req w3
tbl             .req x4
idx             .req x5
step            .req x6
count           .req x7
bits            .req x8

commands:
        and bits, number, #15
        cbz bits, .Lempty               // no actions?
        adrp tbl, actions
        add tbl, tbl, :lo12:actions
        mov count, #4
        mov idx, #0
        mov step, #1
        tbz number, #4, .Lloop
        mov idx, #3                     // reverse order
        mov step, #-1
.Lloop:
        lsr bits, number, idx 
        tbz bits, #0, .Lnext
        add src, tbl, idx, lsl #5
.Lcopy:
        ldrb ch, [src], #1
        strb ch, [buffer], #1
        cbnz ch, .Lcopy
        sub buffer, buffer, #1
.Lnext:
        add idx, idx, step
        subs count, count, #1
        b.ne .Lloop

        strb wzr, [buffer, #-2]         // replace trailing ", " with NUL
        ret
.Lempty:
        strb wzr, [buffer]
        ret
