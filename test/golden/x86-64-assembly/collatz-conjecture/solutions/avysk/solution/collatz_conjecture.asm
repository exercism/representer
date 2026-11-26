section .text
global steps
steps:
        mov         rax, 0
        cmp         edi, 0
        jle         error
loop:   cmp         edi, 1
loop1:  jz          out
        inc         rax
        test        edi, 1
        jnz         odd
        shr         edi, 1
        jmp         loop
odd:    mov         ecx, edi
        shl         edi, 1
        add         edi, ecx
        add         edi, 1
        jmp         loop1
error:  mov         rax, -1
out:    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
