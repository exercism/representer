section .text
global to_rna
to_rna:
    mov r10, rdi
    mov r11, rsi
next:
    mov r8b, byte [r10]
    cmp r8b, 0
    je done
    inc r10
    cmp r8b, 'G'
    jne is_c
    mov byte [r11], 'C'
    jmp next_char
is_c:
    cmp r8b, 'C'
    jne is_t
    mov byte [r11], 'G'
    jmp next_char
is_t:
    cmp r8b, 'T'
    jne is_a
    mov byte [r11], 'A'
    jmp next_char
is_a:
    cmp r8b, 'A'
    jne next_char
    mov byte [r11], 'U'
next_char:
    inc r11
    jmp next
done:
    mov byte [r11], 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
