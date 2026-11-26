.text
.globl nucleotide_counts

output          .req x0
strand          .req x1
counts          .req x7 // same as count_a
count_a         .req x7
count_c         .req x8
count_g         .req x9
count_t         .req x10
ch              .req w11
total           .req x12
cursor          .req x13
length          .req x14

nucleotide_counts:
        mov     count_a, #0
        mov     count_c, #0
        mov     count_g, #0
        mov     count_t, #0
        mov     cursor, strand
        b       .Lstart
.Lloop:
        cmp     ch, #'A'
        cinc    count_a, count_a, eq
        cmp     ch, #'C'
        cinc    count_c, count_c, eq
        cmp     ch, #'G'
        cinc    count_g, count_g, eq
        cmp     ch, #'T'
        cinc    count_t, count_t, eq
.Lstart:
        ldrb    ch, [cursor], #1
        cbnz    ch, .Lloop

        sub     length, cursor, strand
        sub     length, length, #1

        add     total, count_a, count_c
        add     total, total, count_g
        add     total, total, count_t

        // counts = count_a, so count_a is already in bits 0–15
        bfi     counts, count_c, #16, #16
        bfi     counts, count_g, #32, #16
        bfi     counts, count_t, #48, #16

        cmp     length, total           // every char was a nucleotide?
        csinv   counts, counts, xzr, eq

        str     counts, [output]
        ret
