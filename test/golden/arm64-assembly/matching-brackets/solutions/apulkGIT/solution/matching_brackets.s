.section .bss
tmp: .space 64

.text
.globl is_paired

is_paired:
        ldr x2,=tmp
        mov x4,#0
mainloop:
        ldrb w1,[x0],#1
        cbz w1,endofpaired
        cmp w1,'['
        b.eq toinnerroutine
        cmp w1,'{'
        b.eq toinnerroutine
        cmp w1,'('
        b.eq toinnerroutine
        cmp w1,']'
        b.eq failure
        cmp w1,'}'
        b.eq failure
        cmp w1,')'
        b.eq failure
        b.al mainloop
toinnerroutine:
        mov x3,x2
        strb w1,[x3]
        mov x4,#1
innerloop:
        ldrb w1,[x0],#1
        cbz w1,endofpaired
        cmp w1,'['
        b.eq inneraddtmp
        cmp w1,'{'
        b.eq inneraddtmp
        cmp w1,'('
        b.eq inneraddtmp
        cmp w1,']'
        b.eq innerremovetmp
        cmp w1,'}'
        b.eq innerremovetmp
        cmp w1,')'
        b.eq innerremovetmp
        b.al innerloop
inneraddtmp:
        add x3,x3,#1
        strb w1,[x3]
        add x4,x4,#1
        b.al innerloop
innerremovetmp:
        ldrb w5,[x3]
        cmp w5,'['
        b.ne next1
        cmp w1,']'
        b.ne failure
        b.al removefrom
next1:
        cmp w5,'{'
        b.ne next2
        cmp w1,'}'
        b.ne failure
        b.al removefrom
next2:
        cmp w5,'('
        b.ne failure
        cmp w1,')'
        b.ne failure
removefrom:
        sub x3,x3,#1
        sub x4,x4,#1
        cbnz x4,innerloop
        b.al mainloop
failure:
        mov x0,#0
        ret
endofpaired:
        cbnz x4,failure
        mov x0,#1
        ret
