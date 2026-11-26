.text
.globl leap_year

leap_year:
    mov w1, #4
    udiv w2, w0, w1
    mul w2, w2, w1

    cmp w0, w2
    b.eq fourhun

    mov w0, #0
    ret

equal:
    mov w0, #2
    ret

fourhun:
        mov w1,#400
        udiv w2,w0,w1
        mul w2,w2,w1
        cmp w2,w0
        b.eq equal

        b hund
        

hund:
        mov w1,#100
        udiv w2,w0,w1
        mul w2,w2,w1
        cmp w2,w0
        b.ne equal
        mov w0, #0
        ret
        

