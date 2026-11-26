.data
wink: .string "wink"
blink: .string "double blink"
closeyoureyes: .string "close your eyes"
jump: .string "jump"

.section .bss
tmp: .space 32

.text
.globl commands

// x0 dest addr, x2 src addr, x4 count
copystrings:
copystrings_loop:
        ldrb w3, [x2], #1
        cbz w3,copystrings_done
        strb w3, [x0], #1
        b.al copystrings_loop
copystrings_done:
        strb w3, [x0]
        ret

commands:
        stp fp, lr, [sp, -16]!
        mov x6,#1
        eor x4,x4,x4
        ldr x5,=tmp
        tst x1,x6
        b.eq blinkmaybe
        add x4,x4,#1
        ldr x2,=wink
        str x2,[x5],#8
blinkmaybe:
        lsl x6,x6,#1
        tst x1,x6
        b.eq closeyoureyesmaybe
        add x4,x4,#1
        ldr x2,=blink
        str x2,[x5],#8
closeyoureyesmaybe:
        lsl x6,x6,#1
        tst x1,x6
        b.eq jumpmaybe
        add x4,x4,#1
        ldr x2,=closeyoureyes
        str x2,[x5],#8
jumpmaybe:
        lsl x6,x6,#1
        tst x1,x6
        b.eq reverse
        add x4,x4,#1
        ldr x2,=jump
        str x2,[x5],#8
reverse:
        lsl x6,x6,#1
        tst x1,x6
        b.eq docopy
        ldr x5,=tmp
        mov x2,#8
        mul x6,x4,x2
        mov x7,#0
        lsr x8,x4,#1
reverseloop:
        cbz x8,docopy
        sub x6,x6,#8
        ldr x2,[x5,x7]
        ldr x3,[x5,x6]
        str x3,[x5,x7]
        str x2,[x5,x6]
        add x7,x7,#8
        sub x8,x8,#1
        b.al reverseloop
docopy:
        ldr x5,=tmp
copyloop:
        cbz x4,end
        ldr x2,[x5],#8
        bl copystrings
        sub x4,x4,#1
        cbz x4,end
        mov w3,','
        strb w3,[x0],#1
        mov w3,' '
        strb w3,[x0],#1
        b.al copyloop
end:
        mov w3,#0
        strb w3,[x0]
        ldp fp, lr, [sp], 16
        ret
