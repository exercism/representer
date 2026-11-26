.data

letter1: .string "a"
letter2: .string "e"
letter3: .string "i"
letter4: .string "o"
letter5: .string "u"
letter6: .string "xr"
letter7: .string "yt"
letters: .dword letter1
         .dword letter2
         .dword letter3
         .dword letter4
         .dword letter5
         .dword letter6
         .dword letter7
         .dword 0
ay: .string "ay"
consonantss: .string "bcdfghjklmnpqrstvwxz"

.text
.globl translate

getlength:
lenloop:
        ldrb w3, [x1, x2] 
        cmp w3,' '
        b.eq lenok
        cbz w3, lenok
        add x2,x2,#1
        b.al lenloop
lenok:
        ret

// Input: x0 str2, x1 str1, Output: x2 -1 less than, 0 equal, 1 greater than
cmpstrings:
cmploop:
        ldrb w3, [x6], #1
        cbz w3,equal
        ldrb w8, [x1, x7]
        cmp w3,w8
        b.ne notequal
        add x7,x7,#1
        b.al cmploop
notequal:
        mov x3,#1
        ret
equal:  mov x3,#0
        ret

// x0 dest addr, x1 src addr, x7 offset, x2 maxoffset
copystrings:
copystrings_loop:
        cmp x7,x2
        b.eq copystrings_done
        ldrb w3, [x1, x7] 
        cbz w3,copystrings_done
        strb w3, [x0], #1
        add x7,x7,#1
        b.al copystrings_loop
copystrings_done:
        mov w3,#0
        strb w3, [x0]
        ret

translate:
        stp fp, lr, [sp, -16]!
        eor x2,x2,x2
        
mainloop:
        mov x4,x2
        bl getlength
        mov x7,x4
        ldr x5,=letters
        
rule1:
        ldr x6,[x5]
        cbz x6,consonants
        bl cmpstrings
        cbz x3,foundrule1
        add x5,x5,#8
        mov x7,x4
        b.al rule1
foundrule1:
        mov x7,x4
        bl copystrings
        b.al adday
consonants:
        mov x7,x4
        ldrb w3,[x1,x7]
        mov w8,'y'
        cmp w3,w8
        b.ne consloopstart
        add x7,x7,#1
        b.al rule2to4
consloopstart:
        mov x7,x4
consloop:
        ldrb w3,[x1,x7]
        ldr x5,=consonantss
consinnerloop:
        ldrb w8,[x5],#1
        cbz w8,consinnerloopover
        cmp w3,w8
        b.ne consinnerloop
        add x7,x7,#1
        b.al consloop
consinnerloopover:
        cmp x4,x7
        b.eq endofmain
        ldrb w3,[x1,x7]
        cmp w3,'u'
        b.ne rule2to4//rule4
        sub x5,x7,#1
        ldrb w3,[x1,x5]
        cmp w3,'q'
        b.ne rule2to4
        add x7,x7,#2
        b.al rule2to4
//rule4:
        //ldrb w3,[x1,x7]
        //cmp w3,'y'
        //b.ne rule2
        //b.al rule2to4
//rule2: 
  //      b.al rule2to4
        
rule2to4:
        mov x5,x7
        bl copystrings
        mov x6,x2
        mov x2,x5
        mov x7,x4
        bl copystrings
        mov x2,x6
adday:  
        mov x5,x1
        ldr x1,=ay
        eor x7,x7,x7
        mov x6,x2
        mov x2,#2
        bl copystrings
        mov x2,x6
        mov x1,x5
endofmain:
        ldrb w3,[x1,x2]
        cbz w3,end
        mov w3,' '
        strb w3,[x0],#1
        add x2,x2,#1
        b.al mainloop
end:
        ldp fp, lr, [sp], 16
        ret
