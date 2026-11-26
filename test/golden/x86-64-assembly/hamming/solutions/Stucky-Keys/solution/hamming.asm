section .text
global distance
distance:
mov rax, 0
loop:
    cmp byte [rdi], 0
    je null_encountered
    cmp byte [rsi], 0
    je null_encountered

    mov dh, byte [rdi]
    cmp dh, byte [rsi]
    je skip_add
    add rax, 1
skip_add:
    
    add rdi, 1
    add rsi, 1
    jmp loop

null_encountered:
    mov dh, byte [rdi]
    cmp dh, byte [rsi]
    je pass
    mov rax, -1
pass:
    ret
