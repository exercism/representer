section .text
global to_rna
to_rna:
    mov rax, rdi
    mov rcx, rsi
    xor r9, r9

.loop:
    mov r9b, byte [rax]
    test r9b, r9b
    jz .endfunc

    cmp r9b, 'A'
    je .adenine
    cmp r9b, 'C'
    je .cytosine
    cmp r9b, 'G'
    je .guanine
    cmp r9b, 'T'
    je .thymine

    jmp .inc_ops

.adenine:
    mov r9b, 'U'
    jmp .inc_ops
.cytosine:
    mov r9b, 'G'
    jmp .inc_ops
.guanine:
    mov r9b, 'C'
    jmp .inc_ops
.thymine:
    mov r9b, 'A'

.inc_ops:
    mov byte [rcx], r9b
    inc rax
    inc rcx
    jmp .loop

.endfunc:
    mov byte [rcx], 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
