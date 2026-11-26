.equ INVALID_NUMBER, -1

.text
.globl steps

steps:
    mov x10, #0 // x10 will be the counter
    
loop:
    cmp x0, #1      // check if the input number is 1
    beq return      // if so, return

    cmp x0, #0      // compare number to 0...
    ble invalid     // to return the invalid value if so

    add x10, x10, #1    // increment the counter
    tst x0, #1          // is the LSB of x0 equal to 1? Updates the zero flag
    beq even            // is so, jump to even
    b odd               // otherwise, jump to odd

even:
    lsr x0, x0, #1
    b loop

odd:
    add x0, x0, x0, lsl #1 // x0 + (x0 << 1)
    add x0, x0, #1
    b loop

invalid:
    mov x10, #-1    // put -1 in x10
                    // because execution will continue in the return block below
return:
    mov x0, x10 // copy x10 to x0 to return its value
    ret