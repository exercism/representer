section .text
global steps
steps:
    push rdi
    push rdx

    test edi, edi
    jng .iserror

    xor r8, r8
    mov r9, 2
    mov r10, 3
    mov rax, rdi

.loop:
    test rax, 0xFFFFFFFFFFFFFFFE
    jz .endfunc
    ; cmp rax, 1
    ; je .endfunc

    inc r8

    mov r11, rax
    xor rdx, rdx
    div r9

    test rdx, rdx
    jz .loop

    mov rax, r11
    mul r10
    inc rax
    jmp .loop

.iserror:
    mov r8, -1

.endfunc:
    pop rdx
    pop rdi
    mov rax, r8

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
