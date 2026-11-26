section .data
noname: db "One for you, one for me.", 0
sen_start:  db "One for "
sen_end:    db ", one for me.", 0
section .text
global two_fer
two_fer:
    cld
    mov r8, rdi
    mov rdi, rsi
    mov rsi, r8
    test rsi, rsi
    jz no_input
    cmp byte [rsi], 0
    jz no_input
    mov rcx, 8
    lea rsi, [rel sen_start]
    rep movsb
    mov rsi, r8
copy:
    lodsb
    test al, al
    jz next
    stosb
    jmp copy
next:
    mov rcx, 14
    lea rsi, [rel sen_end]
    rep movsb
    jmp end
no_input:
    mov rcx, 25
    lea rsi, [rel noname]
    rep movsb
end:
    ret
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
