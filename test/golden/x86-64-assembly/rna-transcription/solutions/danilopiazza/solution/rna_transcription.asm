default rel

section .rodata
complements:
    times 'A' db 0
    ; A -> U
    db 'U'
    times 'C'-'A'-1 db 0
    ; C -> G
    db 'G'
    times 'G'-'C'-1 db 0
    ; G -> C
    db 'C'
    times 'T'-'G'-1 db 0
    ; T -> A
    db 'A'
    times 256-'T'-1 db 0

section .text
global to_rna
to_rna:
    lea rbx, [complements]
.loop:
    ; while (*rdi)
    movzx rdx, byte [rdi]
    cmp rdx, 0
    je .end
    ; *rsi = complements[*rdi]
    mov rax, rbx
    add rax, rdx
    mov cl, [rax]
    mov [rsi], cl
    ; rdi++, rsi++
    inc rdi
    inc rsi
    jmp .loop
.end:
    ; *rsi = '\0'
    mov byte [rsi], 0
    ret
