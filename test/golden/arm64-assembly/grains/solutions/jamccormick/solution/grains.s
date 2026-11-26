.text
.globl square
.globl total

square:
        mov x1, #1
        cmp x0, #0
        ble _end
        cmp x0, #64
        bgt _end
        sub x0, x0, x1
        lsl x1, x1, x0
        mov x0, x1
        ret

total:
        mov x0, #-1
        ret

_end:
        mov x0, #0
        ret