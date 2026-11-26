# Domino Chain - AArch64
# can_chain(size_t domino_count, const domino_t *dominoes)
# x0 = domino_count, x1 = dominoes
# Retorna 1 se existe circuito euleriano, 0 caso contrario

.text
.globl can_chain

can_chain:
        # Prologo: salva todos os callee-saved usados
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        stp     x25, x26, [sp, #-16]!
        mov     x29, sp
        sub     sp, sp, #1024

        # Argumentos: x0 = count, x1 = ponteiro
        mov     x19, x0
        mov     x20, x1

        # Entrada vazia: cadeia vazia e valida
        cmp     x19, #0
        b.eq    ret_true

        cbz     x20, ret_false

        # Zera os 1024 bytes de trabalho (grau[64] + visitado[64])
        mov     x0, sp
        mov     x1, #128
zera_pilha:
        str     xzr, [x0], #8
        subs    x1, x1, #1
        b.ne    zera_pilha

        # Passo 1: contagem de graus de cada numero (0..63)
        mov     x15, x19
        mov     x23, x20
        mov     x25, sp
        add     x26, sp, #512

contagem_loop:
        cmp     x15, #0
        beq     fim_contagem

        ldr     w24, [x23], #4
        and     w21, w24, #0xFFFF
        lsr     w22, w24, #16

        cmp     w21, #63
        b.hi    ret_false
        cmp     w22, #63
        b.hi    ret_false

        ldr     x0, [x25, x21, lsl #3]
        add     x0, x0, #1
        str     x0, [x25, x21, lsl #3]

        ldr     x0, [x25, x22, lsl #3]
        add     x0, x0, #1
        str     x0, [x25, x22, lsl #3]

        sub     x15, x15, #1
        b       contagem_loop

fim_contagem:
        # Passo 2: todo vertice precisa ter grau par
        mov     x21, #0
verifica_graus:
        cmp     x21, #64
        beq     graus_pares_ok

        ldr     x0, [x25, x21, lsl #3]
        and     x0, x0, #1
        cmp     x0, #1
        beq     ret_false

        add     x21, x21, #1
        b       verifica_graus

graus_pares_ok:
        # Passo 3: acha o primeiro vertice com grau > 0
        mov     x21, #0
acha_inicio:
        cmp     x21, #64
        beq     ret_true

        ldr     x0, [x25, x21, lsl #3]
        cmp     x0, #0
        b.gt    inicia_bfs

        add     x21, x21, #1
        b       acha_inicio

inicia_bfs:
        mov     x0, #1
        str     x0, [x26, x21, lsl #3]

bfs_passo:
        mov     x1, #0
        mov     x23, x20
        mov     x15, x19

bfs_varre:
        cmp     x15, #0
        beq     bfs_checa_mudanca

        ldr     w24, [x23], #4
        and     w21, w24, #0xFFFF
        lsr     w22, w24, #16

        cmp     w21, #63
        b.hi    proximo_dom
        cmp     w22, #63
        b.hi    proximo_dom

        ldr     x0, [x26, x21, lsl #3]
        cmp     x0, #1
        b.ne    tenta_inverso

        ldr     x0, [x26, x22, lsl #3]
        cmp     x0, #0
        b.ne    tenta_inverso

        mov     x0, #1
        str     x0, [x26, x22, lsl #3]
        mov     x1, #1
        b       proximo_dom

tenta_inverso:
        ldr     x0, [x26, x22, lsl #3]
        cmp     x0, #1
        b.ne    proximo_dom

        ldr     x0, [x26, x21, lsl #3]
        cmp     x0, #0
        b.ne    proximo_dom

        mov     x0, #1
        str     x0, [x26, x21, lsl #3]
        mov     x1, #1

proximo_dom:
        sub     x15, x15, #1
        b       bfs_varre

bfs_checa_mudanca:
        cmp     x1, #1
        b.eq    bfs_passo

        # Passo 4: todo vertice com grau > 0 precisa estar visitado
        mov     x21, #0
checa_alcancados:
        cmp     x21, #64
        beq     ret_true

        ldr     x0, [x25, x21, lsl #3]
        cmp     x0, #0
        b.eq    proximo_vertice

        ldr     x0, [x26, x21, lsl #3]
        cmp     x0, #0
        b.eq    ret_false

proximo_vertice:
        add     x21, x21, #1
        b       checa_alcancados

ret_true:
        mov     x0, #1
        b       retorna

ret_false:
        mov     x0, #0
        b       retorna

retorna:
        # Epilogo espelhado na ordem inversa do prologo
        add     sp, sp, #1024
        ldp     x25, x26, [sp], #16
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
        