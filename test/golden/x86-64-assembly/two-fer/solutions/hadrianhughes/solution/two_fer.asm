section .rodata
msg_start:  db "One for ", 0
msg_end:    db ", one for me.", 0
msg_you:    db "you", 0

section .text
global two_fer
two_fer:
    mov rax, rdi ;move name argument to rax
    mov rdi, rsi ;move destination buffer to rdi

    lea rsi, [rel msg_start] ;put msg_start in movsb source register
    call append_string

    cmp rax, 0 ;if no name argument was given
    je add_default
    mov rsi, rax ;move name arg to movsb source register
    jmp continue

    add_default:
    lea rsi, [rel msg_you]

    continue:
    call append_string ;append the string we just selected

    lea rsi, [rel msg_end]
    call append_string

    mov byte [rdi], 0
    ret

append_string: ;add all bytes from string in rbx to rsi
    movsb
    cmp byte [rsi], 0
    jne append_string
    ret
