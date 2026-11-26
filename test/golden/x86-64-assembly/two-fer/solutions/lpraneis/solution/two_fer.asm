default rel

section .rodata
name: db "you", 0
prefix: db "One for "
prefix_len: equ $-prefix
suffix: db ", one for me.", 0
suffix_len: equ $-suffix

section .text

global two_fer
two_fer:
    ; rdi = name
    ; rsi = buffer to store it in

    mov rax, rdi
    mov rdi, rsi

    ; move the prefix to the buffer
    lea rsi, [prefix]
    mov rcx, prefix_len
    rep movsb

    ; If we don't have a default name
    cmp rax, 0
    jne move_name
    lea rax, [name]

move_name:
    mov rsi, rax

move_char:
    cmp byte[rsi], 0
    je move_suffix
    movsb
    loop move_char

move_suffix:
    lea rsi, [suffix]
    mov rcx, suffix_len
    rep movsb
    ret
