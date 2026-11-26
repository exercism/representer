section .text
global is_pangram
is_pangram:
    mov rax, 0
loop:
    mov cl, [rdi]
    test cl, cl
    jz return
    cmp cl, 'A'
    jl skip
    cmp cl, 'Z'
    jle capital_letter
    cmp cl, 'a'
    jl skip
    cmp cl, 'z'
    jg skip
    sub cl, 'a'
    jmp skip_capital_letter
capital_letter:
    sub cl, 'A'
skip_capital_letter:
    mov rdx, 1
    shl rdx, cl
    or rax, rdx
skip:
    inc rdi
    jmp loop
return:
    xor rax, 3FFFFFFh
    sete cl
    xor rax, rax
    mov al, cl
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
