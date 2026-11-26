// uint64_t square_of_sum(uint64_t n)
    .text
    .global square_of_sum
square_of_sum:
    // s = n*(n+1)/2 ; return s*s
    mov     x1, x0            // x1 = n
    add     x2, x0, #1        // x2 = n+1
    mul     x3, x1, x2        // x3 = n*(n+1)
    lsr     x3, x3, #1        // x3 = s = /2
    mul     x0, x3, x3        // x0 = s*s
    ret

// uint64_t sum_of_squares(uint64_t n)
    .global sum_of_squares
sum_of_squares:
    // Σ i^2 = n*(n+1)*(2n+1)/6 = ((.../3)/2)
    mov     x1, x0            // x1 = n
    add     x2, x0, #1        // x2 = n+1
    mul     x3, x1, x2        // x3 = n*(n+1)
    lsl     x4, x0, #1        // x4 = 2n
    add     x4, x4, #1        // x4 = 2n+1
    mul     x5, x3, x4        // x5 = n*(n+1)*(2n+1)
    mov     x6, #3
    udiv    x5, x5, x6        // /3
    lsr     x0, x5, #1        // /2 -> /6 ; return
    ret

// uint64_t difference_of_squares(uint64_t n)
    .global difference_of_squares
difference_of_squares:
    // Prologue: sauver FP/LR + x19,x20 (callee-saved)
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    stp     x19, x20, [sp, #-16]!

    mov     x19, x0           // x19 = n (sauvegarde)

    bl      square_of_sum     // x0 = s^2
    mov     x20, x0           // x20 = s^2 (sauvegarde)

    mov     x0, x19           // restaurer n dans x0
    bl      sum_of_squares    // x0 = Σ i^2

    sub     x0, x20, x0       // x0 = s^2 - Σ i^2

    // Épilogue: restaurer x19,x20 puis FP/LR
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
