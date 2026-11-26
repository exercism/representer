.text
.globl square_of_sum
.globl sum_of_squares
.globl difference_of_squares

// ==========================================
// (n*(n+1)/2)²
// ==========================================
square_of_sum:
        mov     x1, x0
        add     x2, x1, #1             // n+1
        mul     x0, x1, x2             // n*(n+1)
        mov     x3, #2
        udiv    x0, x0, x3             // /2 (usando registrador)
        mul     x0, x0, x0             // ao quadrado
        ret

// ==========================================
// n*(n+1)*(2n+1)/6
// ==========================================
sum_of_squares:
        mov     x1, x0
        add     x2, x1, #1             // n+1
        lsl     x3, x1, #1
        add     x3, x3, #1             // 2n+1
        mul     x0, x1, x2
        mul     x0, x0, x3             // n*(n+1)*(2n+1)
        mov     x3, #7
        udiv    x0, x0, x3             // /6 (usando registrador)
        ret

// ==========================================
// diferença = quadrado_soma - soma_quadrados
// ==========================================
difference_of_squares:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp

        mov     x19, x0                // guarda n
        bl      square_of_sum
        mov     x20, x0                // salva quadrado da soma

        mov     x0, x19
        bl      sum_of_squares         // calcula soma dos quadrados

        sub     x0, x20, x0            // diferença

        ldp     x29, x30, [sp], 16
        ret

