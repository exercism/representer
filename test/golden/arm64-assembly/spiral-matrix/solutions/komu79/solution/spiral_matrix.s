.text
.globl spiral_matrix

dest    .req x0
size    .req x1
n       .req w7
dx      .req x8
dy      .req x9
limit   .req x10
index   .req x11
tmp     .req x12
step    .req x13
seg     .req x14
len     .req x15

spiral_matrix:
        mul     limit, size, size
        mov     n, #1
        mov     index, #0
        mov     dx, #1
        mov     dy, #0
        mov     step, #1
        mov     seg, size
        mov     len, size
        b       .Lcheck
.Lloop:
        str     n, [dest, index, lsl #2]
        add     n, n, #1
        subs    len, len, #1
        b.ne    .Lmove
        mov     tmp, dx             // run done: turn right (dx,dy) = (-dy,dx)
        neg     dx, dy
        mov     dy, tmp
        cbnz    dx, .Lreload        // horizontal run keeps the same length
        sub     seg, seg, #1        // each vertical run is one shorter
.Lreload:
        mov     len, seg
        madd    step, dy, size, dx
.Lmove:
        add     index, index, step
.Lcheck:
        cmp     limit, n, uxtw      // assumes size*size < 2^32
        b.hs    .Lloop
        mov     x0, limit
        ret
