section .text
global steps
steps:
    mov rax, -1
    cmp edi, 0
    jle return
loop:
    inc rax
    cmp rdi, 1
    jz return
    test rdi, 1
    jz even
    mov rsi, rdi
    shl rdi, 1
    add rdi, rsi
    inc rdi
    jmp loop
even:
    shr rdi, 1
    jmp loop
return:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
