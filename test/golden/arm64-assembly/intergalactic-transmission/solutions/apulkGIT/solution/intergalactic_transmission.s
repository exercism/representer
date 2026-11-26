.equ WRONG_PARITY, -1

.text
.globl transmit_sequence
.globl decode_message

// Input: x0 dest, x1 msg, x2 msg len
transmit_sequence:
        lsl x3,x2,#3
        mov x11,#0
        add x2,x3,#6
        mov x4,#7
        udiv x2,x2,x4        
        sub x2,x2,#1
        mov x5,#0 // bitsi
transmitloop:
        cmp x5,x3
        b.ge endoftransmit
        mov x4,#8
        udiv x6,x5,x4
        ldrb w7,[x1,x6]
        msub x6,x6,x4,x5
        lsl w7,w7,w6
        cmp x6,#2
        b.lt bytex
        cmp x11,x2
        b.ge bytex
        add x9,x5,#7
        lsr x9,x9,#3
        ldrb w9,[x1,x9]
        sub x6,x4,x6
        lsr w9,w9,w6
        add w7,w7,w9 // w7 = byte
bytex:
        mov x4,#0xfe
        and w7,w7,w4
        mov w9,w7
        mov x6,#0 // l
        mov x4,#2
bitloop:
        cmp w9,#0
        b.eq endofbitloop
        udiv w8,w9,w4
        msub w10,w8,w4,w9
        cmp w10,#1
        b.ne bitloopinner
        add x6,x6,#1
bitloopinner:
        mov w9,w8
        b.al bitloop
endofbitloop:
        udiv w8,w6,w4
        msub w10,w8,w4,w6
        cmp w10,#1
        b.ne donotor
        orr w7,w7,#1
donotor:
        strb w7,[x0],#1
        add x5,x5,#7
        add x11,x11,#1
        b.al transmitloop
endoftransmit:
        mov x0,x11
        ret

// Input: x0 dest, x1 message, x2 message len
decode_message:
        mov x4,#7
        mul x3,x2,x4
        lsr x3,x3,#3
        lsl x3,x3,#3 // x3==maxbits (message_length*7/8)*8;
        mov x5,#0 // i
        mov x6,#0 // bitsi
decodeloop:
        cmp x6,x3
        b.ge endofdecode
        mov x4,#7
        udiv x7,x6,x4
        ldrb w7,[x1,x7]
        mov w11,w7 // w11 = BYTE 1
        and w7,w7,#0xfe
        mov x4,#2
        mov x8,#0
bitloop1:
        cbz w7,endofbitloop1
        udiv w9,w7,w4
        msub w10,w9,w4,w7
        cmp w10,#1
        b.ne bitloop1inner
        add x8,x8,#1
bitloop1inner:
        mov w7,w9
        b.al bitloop1
endofbitloop1:
        udiv w9,w8,w4
        msub w9,w9,w4,w8
        and w7,w11,#1
        cmp w9,w7
        b.eq noterror
        mov x0,WRONG_PARITY
        ret
noterror:
        mov x4,#7
        add x7,x6,x4
        udiv x7,x7,x4
        ldrb w7,[x1,x7]
        mov w12,w7 // w12 = BYTE 2
        and w7,w7,#0xfe
        mov x4,#2
        mov x8,#0
bitloop2:
        cbz w7,endofbitloop2
        udiv w9,w7,w4
        msub w10,w9,w4,w7
        cmp w10,#1
        b.ne bitloop2inner
        add x8,x8,#1
bitloop2inner:
        mov w7,w9
        b.al bitloop2
endofbitloop2:
        udiv w9,w8,w4
        msub w9,w9,w4,w8
        and w7,w12,#1
        cmp w9,w7
        b.eq noterror2
        mov x0,WRONG_PARITY
        ret
noterror2:
        mov x4,#7
        udiv x7,x6,x4
        msub x7,x7,x4,x6
        and w11,w11,#0xfe
        lsl w11,w11,w7
        sub x7,x4,x7
        lsr w12,w12,w7
        add w11,w11,w12
        strb w11,[x0],#1
        add x5,x5,#1
        add x6,x6,#8
        b.al decodeloop
endofdecode:
        mov x0,x5
        ret
