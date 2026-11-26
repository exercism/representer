section .text
global find
find:
    xor rcx, rcx
.L0:
    cmp rcx, rsi
    je .L3
    lea rax, [rsi + rcx]
    shr rax, 1
    cmp edx, [rdi + rax * 4]
    jb .L1
    ja .L2
    ret
.L1:
    mov rsi, rax
    jmp .L0
.L2:
    lea rcx, [rax + 1]
    jmp .L0
.L3:
    mov rax, -1
    ret
