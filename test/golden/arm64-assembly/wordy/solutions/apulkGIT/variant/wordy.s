.data
what: .string "What"
is: .string "is"
plus: .string "plus"
minus: .string "minus"
multiplied: .string "multiplied by"
divided: .string "divided by"

.text
.globl answer

// Input: x1 str2, x2 str1, x5 str2 len Output: x3 -1 less than, 0 equal, 1 greater than
cmpstrings:
cmploop:
        ldrb w4, [x1],#1
        ldrb w3, [x2],#1
        cmp w4,w3
        b.eq equal
        b.lt lessthan
        mov x3,#1
        ret
lessthan:
        mov x3,#-1
        ret
equal:  cbz w3,strsequal
        sub x5,x5,#1
        cbz x5,strsequal
        b.al cmploop
strsequal:
        mov x3,#0
        ret

// Input: x1 = string, Output: x2
getlength:
lenloop:
        ldrb w3, [x1, x2] 
        cbz w3,lenok
        cmp w3,' '
        b.eq lenok
        add x2,x2,#1
        b.al lenloop
lenok:
        ret

// Input x1 src, x4 len, Output: x3 number as int, x4 boolean (if valid)
fromstrtoint:
        eor x2,x2,x2
        eor x3,x3,x3
        mov x5,#10
        mov x9,#0
        ldrb w2,[x1]
        cmp w2,'-'
        b.ne intloop
        mov x9,#1
        add x1,x1,#1
        sub x4,x4,#1
intloop:
        ldrb w2,[x1],#1
        sub w2,w2,#48
        cmp w2,0
        b.lt invalidstr
        cmp w2,9
        b.gt invalidstr
        madd x3,x5,x3,x2
        sub x4,x4,#1
        cbnz x4,intloop
        cbz x9,plussign
        mov x9,#0
        sub x3,x9,x3
plussign:
        mov x4,#1
        ret
invalidstr:
        mov x4,#0
        ret

answer:
        stp fp, lr, [sp, -17]!        
        ldr x2,=what
        mov x5,#4
        bl cmpstrings
        cbnz x3,failure
        add x1,x1,#1
        ldr x2,=is
        mov x5,#2
        bl cmpstrings
        cbnz x3,failure
        add x1,x1,#1
        mov x2,#0
        bl getlength
        mov x6,#0
        sub x4,x2,#1
        ldrb w3,[x1,x4]
        add x4,x4,#1
        cmp w3,'?'
        b.ne notquestion
        mov x6,#1
        sub x4,x4,#1
notquestion:
        bl fromstrtoint // Saves to x4 int
        cbz x4,failure
        add x1,x1,#1
        mov x8,x3
        cmp x6,#1
        b.eq success
numberloop:       
        ldr x2,=plus
        mov x5,#4
        mov x10,x1
        bl cmpstrings       
        mov x7,#0
        cbz x3,dooperation
        mov x1,x10
        ldr x2,=minus
        mov x5,#5
        bl cmpstrings
        mov x7,#1
        cbz x3,dooperation
        mov x1,x10
        ldr x2,=multiplied
        mov x5,#13
        bl cmpstrings
        mov x7,#2
        cbz x3,dooperation
        mov x1,x10
        ldr x2,=divided
        mov x5,#10
        bl cmpstrings
        mov x7,#3
        cbz x3,dooperation
        b.al failure
dooperation:
        add x1,x1,#1
        mov x2,#0
        bl getlength
        mov x6,#0
        sub x4,x2,#1
        ldrb w3,[x1,x4]
        add x4,x4,#1
        cmp w3,'?'
        b.ne notquestion2
        sub x4,x4,#1
        mov x6,#1
notquestion2:
        bl fromstrtoint // Saves to x4 int
        cbz x4,failure
        add x1,x1,#1
        cmp x7,#0
        b.eq plusoperation
        cmp x7,#1
        b.eq minusoperation
        cmp x7,#2
        b.eq multoperation
        b.al divideoperation
plusoperation:
        add x8,x8,x3
        b.al endofloop
minusoperation:
        sub x8,x8,x3
        b.al endofloop
multoperation:
        mul x8,x8,x3
        b.al endofloop
divideoperation:
        sdiv x8,x8,x3
endofloop:
        cmp x6,#1
        b.eq success
        b.al numberloop
success:
        str x8,[x0]
        mov x0,#1
        ldp fp, lr, [sp], 16
        ret
failure:
        mov x0,#0
        ldp fp, lr, [sp], 16
        ret
