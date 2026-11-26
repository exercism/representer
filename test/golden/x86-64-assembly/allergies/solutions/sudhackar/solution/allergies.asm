section .text
global allergic_to
allergic_to:
    xor eax, eax
    bts rsi, rdi
    setc al
    ret

global list
list:
    xor eax, eax
    xor edx, edx
    jmp loop
    loop:
        test dil, 1
        je not_set
        movsx rcx, edx
        inc edx
        mov dword [rsi+rcx*4+4], eax
        not_set:
        inc eax
        shr edi, 1
        cmp eax, 8
        jne loop
    mov dword [rsi], edx
    ret
