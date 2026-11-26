section .text
global leap_year
leap_year:
    mov eax, edi
    ;; divisible by 4
    test eax, 3
    jnz .nope

    ;; divisible by 100
    mov ecx, 100
    cdq
    div ecx
    test edx, edx
    jnz .yup

    ;; divisible by 400
    mov eax, edi
    mov ecx, 400
    cdq
    div ecx
    test edx, edx
    jz .yup
    
.nope:
    mov eax, 0
    ret
.yup:
    mov eax, 1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
