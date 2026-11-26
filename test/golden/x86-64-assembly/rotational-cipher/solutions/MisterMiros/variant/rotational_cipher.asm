default rel

section .text
global rotate
rotate:
    xor rax, rax
.loop:
    xor rcx, rcx
    mov cl, [rdi + rax]
    test cl, cl
    jz .done
    cmp cl, 'A'
    jl .next  ; less than 'A' 
    cmp cl, 'Z'
    jle .rotate_upper ; less than 'Z' and greater than 'A'
    cmp cl, 'a'
    jl .next
    cmp cl, 'z'
    jle .rotate_lower
    jmp .next
.rotate_upper:
    add rcx, rsi
    cmp rcx, 'Z'
    jg .shift_upper
    jmp .next
.shift_upper:
    sub rcx, 'Z'
    add rcx, 'A' - 1
    jmp .next
.rotate_lower:
    add rcx, rsi
    cmp rcx, 'z'
    jg .shift_lower
    jmp .next
.shift_lower:
    sub rcx, 'z'
    add rcx, 'a' + 1
    jmp .next
.next:
    mov [rdx + rax], rcx
    inc rax
    jmp .loop
.done:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
