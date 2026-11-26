section .text
global square
square:
    xor rax, rax
    cmp rdi, 0
    jle return
    cmp rdi, 64
    jg return

    dec dil
    mov cl, dil
    inc rax
    shl rax, cl
return:
    ret

global total
total:
    xor rax, rax
    not rax
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
