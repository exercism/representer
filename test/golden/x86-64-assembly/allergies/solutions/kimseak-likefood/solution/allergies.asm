section .text
global allergic_to
allergic_to:
        ;; rdi: allergy to test
        ;; rsi: allergy score

        ;; prepare
        xor eax, eax

        ;; test
        bts si, di
        setc al

        ret

global list
list:
        ;; rdi allergy score
        ;; rsi pointer to output structure

        ;; prepare
        xor r8, r8              ; n-th found allergy
        xor r9, r9              ; currently tested allergy

.l0:
        ;; test one allergy
        test dil, 1
        jz .not_allergic

        ;; store this allergy
        mov [rsi + r8 * 4 + 4], r9d
        inc r8

.not_allergic:
        ;; prepare next
        inc r9

        ;; more to test?
        shr dil, 1
        jnz .l0

        ;; store count
        mov [rsi], r8d

        ret