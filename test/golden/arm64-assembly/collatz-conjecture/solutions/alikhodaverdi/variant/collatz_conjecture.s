.equ INVALID_NUMBER, -2

.text
.global steps

steps:
    cmp x0, #0              
    cbz x0, return_invalid  
    blt return_invalid     
    
    mov x1, #0             

loop:
    cmp x0, #1
    beq done

    and x2, x0, #1
    cbz x2, even

    mov x3, x0
    lsl x0, x0, #1
    add x0, x0, x3
    add x0, x0, #1
    b next

even:
    lsr x0, x0, #1

next:
    add x1, x1, #1
    b loop

done:
    mov x0, x1
    ret

return_invalid:
    mov x0, #-1
    ret