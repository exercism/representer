.data
no:   .string "no"
one:  .string "one"
two:  .string "two"
three:  .string "three"
four:  .string "four"
five:  .string "five"
six:  .string "six"
seven:  .string "seven"
eight:  .string "eight"
nine:  .string "nine"
ten:  .string "ten"
numbers: .dword no
         .dword one
         .dword two
         .dword three
         .dword four
         .dword five
         .dword six
         .dword seven
         .dword eight
         .dword nine
         .dword ten
verse1:  .string " green bottle"
verse12: .string " hanging on the wall,\n"
verse3: .string "And if one green bottle should accidentally fall,\n"
verse4: .string "There'll be "

.text
.globl recite

// x0 dest addr, x2 src addr, x4 count
copystrings:
        eor x5,x5,x5
copystrings_loop:
        ldrb w3, [x2, x5] 
        cbz w3,copystrings_done
        strb w3, [x0, x5] 
        add x5,x5,#1
        b.al copystrings_loop
copystrings_done:
        strb w3, [x0, x5]
        ret

recite:
        stp fp, lr, [sp, -16]!
        sub x8,x1,x2

reciteloop:
        cmp x1,x8
        b.eq end
        
        ldr x2,=numbers
        mov x3,#8
        madd x2,x1,x3,x2        
        ldr x2,[x2]
        bl copystrings
        ldrb w3,[x0]
        sub w3,w3,32
        strb w3,[x0]
        add x0,x0,x5

        ldr x2,=verse1
        bl copystrings
        add x0,x0,x5
        
        mov w3,'s'
        cmp x1,#1
        b.eq bottle
        strb w3,[x0],#1
bottle:
        ldr x2,=verse12
        bl copystrings
        add x0,x0,x5

        ldr x2,=numbers
        mov x3,#8
        madd x2,x1,x3,x2        
        ldr x2,[x2]
        bl copystrings
        
        ldrb w3,[x0]
        sub w3,w3,32
        strb w3,[x0]
        add x0,x0,x5

        ldr x2,=verse1
        bl copystrings
        add x0,x0,x5
        
        mov w3,'s'
        cmp x1,#1
        b.eq bottle2
        strb w3,[x0],#1
bottle2:
        ldr x2,=verse12
        bl copystrings
        add x0,x0,x5

        ldr x2,=verse3
        bl copystrings
        add x0,x0,x5
       
        ldr x2,=verse4
        bl copystrings
        add x0,x0,x5

        ldr x2,=numbers
        mov x3,#8
        madd x2,x1,x3,x2
        sub x2,x2,#8
        ldr x2,[x2]
        bl copystrings
        add x0,x0,x5

        ldr x2,=verse1
        bl copystrings
        add x0,x0,x5
        
        mov w3,'s'
        cmp x1,#2
        b.eq bottle3
        strb w3,[x0],#1
bottle3:
        ldr x2,=verse12
        bl copystrings
        add x0,x0,x5
        sub x2,x0,#2
        mov w3,'.'
        strb w3,[x2]

        add x2,x8,#1
        cmp x1,x2
        b.eq donotdolf
        mov w3,'\n'
        strb w3, [x0],#1
donotdolf:
        sub x1,x1,#1
        b.al reciteloop
end:
        ldp fp, lr, [sp], 16
        ret
