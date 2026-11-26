.text
.globl response

response:
    mov     x1, x0
    mov     x9, #0
    mov     x10, #0
    mov     x11, #0
    mov     x12, #0

.loop:
    ldrb    w13, [x1], #1
    cbz     w13, .done
    cmp     w13, #0x20
    beq     .loop
    cmp     w13, #0x09
    beq     .loop
    cmp     w13, #0x0a
    beq     .loop
    cmp     w13, #0x0d
    beq     .loop
    mov     x11, #1
    mov     x12, x13
    cmp     w13, #0x41
    blt     .loop
    cmp     w13, #0x5a
    ble     .upper
    cmp     w13, #0x61
    blt     .loop
    cmp     w13, #0x7a
    ble     .lower
    b       .loop

.upper:
    mov     x9, #1
    b       .loop

.lower:
    mov     x9, #1
    mov     x10, #1
    b       .loop

.done:
    cbz     x11, .silence
    adr     x0, str_whatever
    cmp     x12, #0x3f
    b.eq    .is_question
    cbz     x9, .return
    cbnz    x10, .return
    adr     x0, str_whoa
    ret

.is_question:
    adr     x0, str_sure
    cbz     x9, .return
    cbnz    x10, .return
    adr     x0, str_calmdown
    ret

.silence:
    adr     x0, str_fine

.return:
    ret

str_fine:       .asciz "Fine. Be that way!"
str_whoa:       .asciz "Whoa, chill out!"
str_sure:       .asciz "Sure."
str_calmdown:   .asciz "Calm down, I know what I'm doing!"
str_whatever:   .asciz "Whatever."
