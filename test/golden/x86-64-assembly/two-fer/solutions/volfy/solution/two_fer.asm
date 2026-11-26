default rel

section .rodata
one_for: db "One for "
one_for_len: equ $ - one_for

you: db "you"
you_len: equ $ - you

one_for_me: db ", one for me.", 0
ofm_len: equ $ - one_for_me

section .text
global two_fer
two_fer:
    mov rax, rdi ; save the input

    mov rdi, rsi ; destination for str is buffer
    lea rsi, [one_for] ; load src string addr
    mov rcx, one_for_len
    rep movsb

    ; copy name, or "you"
    test rax, rax
    jnz .copy_name

    lea rsi, [you]
    mov rcx, you_len
    rep movsb
    jmp .endfunc

.copy_name:
    mov rsi, rax
    cmp byte [rsi], 0
    je .endfunc

.copy_name_loop:
    movsb
    cmp byte [rsi], 0
    jne .copy_name_loop

.endfunc:
    lea rsi, [one_for_me] ; src str
    mov rcx, ofm_len
    rep movsb

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
