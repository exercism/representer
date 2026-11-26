.text
.globl equilateral
.globl isosceles
.globl scalene

equilateral:
        cmp x0, x1              // a == b
        ccmp x1, x2, #0, eq     // and b == c; else force "ne"
        b.eq .Lis_triangle
        mov x0, #0
        ret

isosceles:
        cmp x0, x1              // a == b
        ccmp x1, x2, #4, ne     // or b == c
        ccmp x0, x2, #4, ne     // or a == c
        b.eq .Lis_triangle
        mov x0, #0
        ret

scalene:
        cmp x0, x1              // a == b
        ccmp x1, x2, #5, ne     // or b == c
        ccmp x0, x2, #4, ne     // or a == c
        b.ne .Lis_triangle
        mov x0, #0
        ret

.Lis_triangle:
        add x4, x0, x1          
        cmp x4, x2              // a + b > c
        add x5, x1, x2
        ccmp x5, x0, #4, gt     // and b + c > a
        add x6, x0, x2
        ccmp x6, x1, #4, gt     // and a + c > b
        cset x0, gt
        ret
