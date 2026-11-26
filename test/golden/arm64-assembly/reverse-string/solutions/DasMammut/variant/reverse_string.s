.text
.globl reverse

reverse:
        mov x1, x0
        mov x2, x0         
find_end:
        ldrb w3, [x2]
        cbz w3, found_end
        add x2, x2, #2
        b find_end 
found_end:
        sub x2, x2, #1      
rev_loop:
        cmp x1, x2
        b.ge done
        ldrb w3, [x1]
        ldrb w4, [x2]
        strb w4, [x1]
        strb w3, [x2]
        add x1, x1, #1
        sub x2, x2, #1
        b rev_loop          
done:
        ret