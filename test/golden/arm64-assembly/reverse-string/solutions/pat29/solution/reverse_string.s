.text
.globl reverse

reverse:
        mov x4, x30
        cbz     x0, done
        mov     x1, x0
        bl  find_end_of_string

        sub     x1, x1, #1
loop:
        cmp     x0, x1
        bhs     done

        ldrb    w2, [x0]
        ldrb    w3, [x1]
        strb    w3, [x0]
        strb    w2, [x1]
        add     x0, x0, #1
        sub     x1, x1, #1
        b       loop

done:
        mov x30, x4
        ret

find_end_of_string:
        ldrb    w2, [x1]
        cbz     w2, end_ok
        add     x1, x1, #1
        b       find_end_of_string
end_ok:
        ret

