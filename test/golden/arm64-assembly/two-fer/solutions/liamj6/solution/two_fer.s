.data
msg: .ascii "One for \0, one for me.\0"
.text
.globl two_fer

.pcpy:  ldrb w5, [x2], #1
        strb w5, [x0], #1
        cbnz w5, .pcpy
        sub x0, x0, #1
        ret
two_fer:mov x20, x30
        ldr x2, =msg
        bl .pcpy
        adds x2, x1, #0
        cbnz x2, .pname
.pnull: mov x5, #28537
        str x5, [x0], #2
        mov x5, #'u'
        str x5, [x0], #1
        b .ptail
.pname: mov x2, x1
        bl .pcpy
.ptail: ldr x2, =msg
        add x2, x2, #9
        bl .pcpy
        ret x20

