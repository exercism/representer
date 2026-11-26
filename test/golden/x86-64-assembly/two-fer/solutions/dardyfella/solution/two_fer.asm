default rel

section .rodata
msg_part1:    db "One for ", 0
default_name: db "you", 0
msg_part2:    db ", one for me.", 0


section .text
global two_fer
two_fer:
    xchg rsi, rdi ; Swap name and buffer arguments
    mov r8, rsi   ; Save name pointer for later 


    ; Write out first part of message
    lea rsi, [msg_part1]
    mov rcx, 8
    rep movsb


    mov rsi, r8 ; Restore name pointer from ealier
    cmp rsi, 0
    je is_name_null
        ; Poor man's strlen
        xor rcx, rcx ; Zero name length
        strlen_loop:
            cmp byte [r8], 0
            je is_name_notnull
            inc rcx
            inc r8
        jmp strlen_loop
               
    is_name_null:
        lea rsi, [default_name]
        mov rcx, 3

    is_name_notnull:
    ; Write out name
    rep movsb


    ; Write out last part of message
    lea rsi, [msg_part2]
    mov rcx, 14
    rep movsb

    ret
