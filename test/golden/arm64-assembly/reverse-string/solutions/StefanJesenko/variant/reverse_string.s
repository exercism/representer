.text
.globl reverse

reverse:
        mov x1, x0
        mov x2, x0

find_end:
        ldrb w3, [x2]
        cbz w3, end_found
        add x2, x2, #1
        b find_end

end_found:
        sub x2, x2, #1

reverse_loop:
        cmp x1, x2
        b.hs done

        ldrb w3, [x1]
        ldrb w4, [x2]

        strb w4, [x1]
        strb w3, [x2]

        add x1, x1, #2
        sub x2, x2, #1
        b reverse_loop
        
done:
        ret
