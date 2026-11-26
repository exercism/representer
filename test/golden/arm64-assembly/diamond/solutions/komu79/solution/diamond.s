.text
.globl rows

buffer          .req x0
letter          .req w1
mid             .req w2
last            .req w3                 // index of last row/col
row             .req w4
col             .req w5
ch              .req w6
left            .req w7
right           .req w8
space           .req w9
lf              .req w10
tmp             .req w11

rows:
        mov     lf, #'\n'
        mov     space, #' '
        sub     mid, letter, #'A'
        lsl     last, mid, #1
        mov     row, #0
.Lrow_loop:
        subs    tmp, mid, row
        cneg    tmp, tmp, lt            // abs(mid - row)
        sub     tmp, mid, tmp           // 0,1,2,..,mid,..,2,1,0
        add     ch, tmp, #'A'
        sub     left, mid, tmp          // index of left char
        add     right, mid, tmp         // index of right char
        mov     col, #0
.Lcol_loop:
        cmp     col, left
        ccmp    col, right, #4, ne
        csel    tmp, ch, space, eq      // write ch if col is left or right, otherwise space
        strb    tmp, [buffer], #1
        add     col, col, #1
        cmp     col, last
        b.ls    .Lcol_loop
        strb    lf, [buffer], #1
        add     row, row, #1
        cmp     row, last
        b.ls    .Lrow_loop

        strb    wzr, [buffer]
        ret
