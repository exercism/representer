# asmsyntax=arm64
.text
.globl format

.eqv buffer_size, 100

// string_append(a, b) -> a
string_append:
    str x0, [sp, -16]!
string_append_s:
    ldrb w2, [x0], 1 // read byte from a
    cbnz w2, string_append_s // loop until we find null
    sub x0, x0, 1 // go back to a's null byte
string_append_l:
    ldrb w2, [x1], 1 // read byte from b
    strb w2, [x0], 1 // store at end of a
    cbnz w2, string_append_l // loop
    ldr x0, [sp], 16
    ret

// int_ascii(output, number) -> void
int_ascii:
    stp fp, lr, [sp, -16]!
    mov fp, sp // fp = one past end of converted string
    sub sp, sp, 16 // allocate buffer
    mov x2, -1 // index into frame
    strb wzr, [fp, x2] // store null byte
    mov x3, 10 // divisor
convert_digits:
    udiv x4, x1, x3 // quotient
    msub x5, x4, x3, x1 // digit = number - quotient * divisor
    add x5, x5, 0x30 // convert digit to ascii
    sub x2, x2, 1 // move index towards top
    cmp x2, -16 // converted string >= 16 bytes?
    b.le write_digits // if yes, limit string length to 16 bytes
    strb w5, [fp, x2] // store ascii in the stack
    mov x1, x4 // input for next iteration
    cbnz x4, convert_digits // if quotient != 0 loop
write_digits:
    add x1, fp, x2 // fp + offset (x6) = address of ascii string
    bl string_append // string_append(x0, x1)
    add sp, sp, 16 // deallocte buffer
    ldp fp, lr, [sp], 16
    ret

// exception_q(number) -> bool
exception_q:
    mov x1, 100 // divisor
    udiv x2, x0, x1 // quotient
    msub x3, x2, x1, x0 // last two digits
    sub x1, x3, 11 // digits - low end of [11, 14)
    cmp x1, 3 // compare to high end of [11, 14)
    cset x0, hs // return 0 if number is within [11, 14)
    ret

// get_cardinal(number) -> addr
get_cardinal:
    stp fp, lr, [sp, -16]!
    mov x19, x0 // save number
    bl exception_q
    cbz x0, get_cardinal_end
    mov x0, x19 // restore number
    mov x1, 10 // divisor
    udiv x2, x0, x1 // quotient
    msub x3, x2, x1, x0 // last digit
    mov x4, 4
    cmp x3, 5 // digit == 4
    csel x0, x3, x4, lt // index = clamp(digit, 0, 4)
get_cardinal_end:
    adr x1, cardinals // load base address
    ldr x0, [x1, x0, lsl 3] // scale offset by 8, load and return target address
    ldp fp, lr, [sp], 16
    ret

// format(buffer, name, number) -> void
format:
    stp fp, lr, [sp, -32]!
    stp x0, x2, [sp, 16] // save buffer

    mov x9, x1
    mov x2, buffer_size
    mov x1, 0
    bl memset
    ldr x0, [sp, 16]
    mov x1, x9
    bl string_append // write name
    adr x1, you_string
    bl string_append // write ", you..."
    ldr x1, [sp, 24] // load the number
    bl int_ascii // write number
    ldr x0, [sp, 24] // load the number
    bl get_cardinal
    mov x1, x0
    ldr x0, [sp, 16]
    bl string_append // write the cardinal ending
    adr x1, customer_string
    bl string_append

    ldp fp, lr, [sp], 32
    ret

.data
you_string:
    .asciz ", you are the "
customer_string:
    .asciz " customer we serve today. Thank you!"
cardinals:
    .dword cardinal_n
    .dword cardinal_1
    .dword cardinal_2
    .dword cardinal_3
    .dword cardinal_n
cardinal_1:
    .asciz "st"
cardinal_2:
    .asciz "nd"
cardinal_3:
    .asciz "rd"
cardinal_n:
    .asciz "th"
