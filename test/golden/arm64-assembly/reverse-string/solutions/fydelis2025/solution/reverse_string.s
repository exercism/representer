.text
.globl reverse

reverse:
        mov        x1, x0

encontrar_fim:
        ldrb       w2, [x1]
        cbz        w2, fim_encontrado
        add        x1, x1, #1
        b          encontrar_fim

fim_encontrado:
        sub        x1, x1, #1
swap_loop:
        cmp        x0, x1
        b.ge       done

        ldrb       w2, [x0]
        ldrb       w3, [x1]
        strb       w3, [x0]
        strb       w2, [x1]

        add        x0, x0, #1
        sub        x1, x1, #1
        b        swap_loop

done:
        ret