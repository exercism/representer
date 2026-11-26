.text
.globl square
.globl total

square:
        cmp x0, #1
        b.lt .Linvalid
        cmp x0, #64
        b.gt .Linvalid
        mov x1, #1
        sub x0, x0, #1
        lsl x0, x1, x0
        ret
.Linvalid:
        mov x0, #0
        ret

total:
        mov x0, #-1
        ret
