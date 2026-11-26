section .text
global distance
distance:
    xor rax, rax
    xor rcx, rcx
loop:
    mov bl, byte [rdi + rcx]
    mov dl, byte [rsi + rcx]
    test bl, bl
    jz end
    test dl, dl
    jz end
    cmp bl, dl
    je next
    inc rax
next:
    inc rcx
    jmp loop
end:
    sub dl, bl
    jz valid
    mov rax, 0xffffffff
valid:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
