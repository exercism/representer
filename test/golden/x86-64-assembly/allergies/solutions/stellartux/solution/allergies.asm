default rel

section .text
global allergic_to
; int allergic_to(enum item item, unsigned int score)
allergic_to:
    mov cl, dil
    mov edx, 1
    xor eax, eax
    shl edx, cl
    test edx, esi
    jz .end
    inc eax
.end:
    ret

global list
; void list(unsigned int score, struct item_list *list)
list:
    mov r8, rsi
    xor r9, r9
    mov rsi, rdi
    xor rdi, rdi
.loop:
    call allergic_to
    jz .next
    inc r9
    mov dword[r8 + 4 * r9], edi
.next:
    inc edi
    cmp edi, 8
    jl .loop
    mov dword[r8], r9d
    ret
