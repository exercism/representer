section .text
global allergic_to
allergic_to:
    xor rax, rax
    bt si, di
    setb al
    ret

global list
list:
    xor rax, rax
    xor rcx, rcx
    ; Eliminate anything above 255.
    and edi, 11111111b
    
.loop:
    ; Check if we're done first.
    cmp edi, 0
    je .end
    
    ; Otherwise, find the lowest set bit, and add it to the array (ENUM).
    ; Then, reset (clear) it.
    bsf eax, edi
    inc rcx
    mov [rsi + 4 * rcx], eax
    blsr edi, edi
    jmp .loop
    
.end:
    mov [rsi], ecx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
